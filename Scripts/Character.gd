extends Resource
class_name Character

# Exported properties
@export var title : String          # Character's name/identifier
@export var icon : Texture2D       # Small icon for UI (e.g., timeline)
@export var texture : Texture2D    # Main sprite texture
@export var max_timeforce : int = 100

# Agility stat (modifies speed and resets queue when changed)
@export var agility : int:
	set(value):
		agility = value
		# Calculate speed using logarithmic scaling (higher agility = faster)
		speed = 200.0 / (log(agility) + 2) - 25
		queue_reset()  # Reset action queue when agility changes

# Internal properties
var speed : float = 100.0           # Default speed if agility doesn't set it
var queue : Array[float] = []       # Action queue (stores time values for turns)
var status = 1                      # Status multiplier (e.g., 1 = normal, 0.5 = slowed)
var node                            # Reference to the character's scene node
var current_timeforce := max_timeforce:
	set(value):
		current_timeforce = clamp(value, 0, max_timeforce)
		timeforce_changed.emit(current_timeforce, max_timeforce)
		if current_timeforce <= 0:
			character_died.emit()
			
signal timeforce_changed(current: float, max: float)
signal character_died

var is_player : bool = false
var is_dead : bool = false

func _init():
	# Initialize speed and queue on creation
	if agility > 0:
		speed = 200.0 / (log(agility) + 2) - 25
	queue_reset()

# Resets/initializes the action queue with time values
func queue_reset():
	queue.clear()  # Clear existing queue
	
	# Generate 4 time entries for the queue
	for i in range(4):
		if queue.size() == 0:
			# First entry: base speed × status (e.g., 100 × 1)
			queue.append(speed * status)
		else:
			# Subsequent entries: previous time + (speed × status)
			queue.append(queue[-1] + speed * status)

# Moves the character smoothly using a tween
func tween_movement(shift, tree):
	var tween = tree.create_tween()
	tween.tween_property(node, "position", node.position + shift, 0.2)
	await tween.finished  # Pause until movement completes

# Handles attack animation (moves forward briefly)
func attack(tree):
	var shift = Vector2(30, 0)  # Default attack dash distance
	
	# Reverse direction if character is on the left side of the screen
	if node.position.x < node.get_viewport_rect().size.x / 2:
		shift = -shift
	
	# Perform attack movement: dash forward, then return
	await tween_movement(-shift, tree)  # Dash toward enemy
	await tween_movement(shift, tree)    # Return to original position
	
	EventBus.next_attack.emit()  # Notify system to proceed to next attack

# Remove oldest queue entry and add a new future turn
func pop_out():
	if queue.size() > 0:
		queue.pop_front()
		queue.append(queue[-1] + speed * status)
	else:
		# Regenerate queue if it's empty
		queue_reset()
	
func take_damage(amount: int):
	if is_dead:
		return  # Don't process damage if already dead
		
	current_timeforce -= amount
	if current_timeforce < 0:
		current_timeforce = 0
	
	if current_timeforce <= 0 and not is_dead:
		is_dead = true
		EventBus.character_died.emit(self)

func restore_time_force(amount: int):
	if is_dead:
		return  # Don't restore if dead
		
	current_timeforce += amount
	if current_timeforce > max_timeforce:
		current_timeforce = max_timeforce
	EventBus.time_force_changed.emit(self)

func use_ability_force(amount: int) -> bool:
	if is_dead or current_timeforce < amount:
		return false
		
	current_timeforce -= amount
	EventBus.time_force_changed.emit(self)
	return true
