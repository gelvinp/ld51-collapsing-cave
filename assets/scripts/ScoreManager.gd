extends Node


var score := 0
var high_score := 0


func add_score(amount: int):
	score += amount
	high_score = max(high_score, score)
