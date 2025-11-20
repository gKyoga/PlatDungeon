extends Label

func _ready():
	Global.score_updated.connect(_on_score_updated)
	
	text = "Score: " + str(Global.score)

func _on_score_updated(new_score: int):
	text = "Score: " + str(new_score)
