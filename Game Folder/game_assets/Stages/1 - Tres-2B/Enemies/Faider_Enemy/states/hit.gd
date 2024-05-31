extends State
@onready var knockback_timer: Timer = $knockback_timer

func enter():
	Transistioned.emit(self, "death")
