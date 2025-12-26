extends Area3D

func _on_body_entered(body):
    if body.name == "Player":
        body.equip_vest()
        queue_free()
