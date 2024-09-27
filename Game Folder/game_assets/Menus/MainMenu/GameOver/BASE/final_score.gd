extends RichTextLabel

var rank_dictionary : Dictionary = {
	"F" : 2500,
	"D" : 5000,
	"C" : 10000,
	"B" : 50000,
	"A" : 100000,
	"S" : 250000,
}

func update_rank_display(final_score) -> StringName:
	for rank in rank_dictionary:
		if final_score <= rank_dictionary[rank]:
			return rank
	return "S+"
