extends HBoxContainer

var number_of_seeds_found = 0

func _ready():
	var seeds = get_tree().get_nodes_in_group("seed")
	for plant_seed in seeds:
		plant_seed.connect("seed_get", self, "_seed_get")

func _seed_get():
	number_of_seeds_found += 1
	if number_of_seeds_found in [1,2,3]:
		get_node("Seed0"+str(number_of_seeds_found)).modulate = Color(1,1,1,1)
