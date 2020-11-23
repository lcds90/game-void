extends StaticBody2D

func _on_Door_ready():
	PlayerData.connect("active", self, "actived")
		
func actived() -> void:
	if(PlayerData.active == true):
		queue_free()
