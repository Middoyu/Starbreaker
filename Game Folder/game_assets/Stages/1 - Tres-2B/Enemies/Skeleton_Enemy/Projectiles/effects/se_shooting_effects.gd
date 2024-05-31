extends GPUParticles2D

func _ready() -> void:
	self.emitting = true

func finished() -> void:
	queue_free()
