extends Node

var cache_ := []

func load_in_cache(path : String):
	cache_.push_back(load(path))
