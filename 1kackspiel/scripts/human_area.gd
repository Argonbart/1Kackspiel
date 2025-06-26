class_name HumanArea
extends Area2D


@export var human: CharacterBody2D


func take_damage(damage: int):
	human.take_damage(damage)
