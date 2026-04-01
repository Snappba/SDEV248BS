extends Control

@onready var lives_label: Label = $Label_Lives
@onready var dollas_label: Label = $Label_Dollas


func update_hud(lives: int, dollas: int):
	lives_label.text = "Lives: " + str(lives)
	dollas_label.text = "Dollas: " + str(dollas)
