extends Node


signal updated
signal died	
signal killed
signal active

var score: = 0 setget set_score
var deaths: = 0 setget set_deaths
var kills: = 0 setget set_kills
var active: = false setget set_active_phase

func reset():
	self.score = 0
	self.deaths = 0
	self.kills = 0
	self.active = false


func set_score(new_score: int) -> void:
	score = new_score
	emit_signal("updated")


func set_deaths(new_value: int) -> void:
	deaths = new_value
	emit_signal("died")

func set_kills(new_value: int) -> void:
	kills = new_value
	emit_signal("killed")

func set_active_phase(is_active: bool) -> void:
	active = is_active
	emit_signal("active")
