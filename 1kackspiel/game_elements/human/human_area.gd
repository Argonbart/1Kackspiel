class_name HumanArea
extends Area2D


@export var human: Human


func take_damage(damage: int):
	human.take_damage(damage)
