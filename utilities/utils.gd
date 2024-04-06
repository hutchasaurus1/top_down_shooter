extends Node

func weighted_selection(probabilities: Array) -> int:
	var total_probability: float = 0.0
	var cumulative_probabilities: Array = []
	
	# Calculate the cumulative sum of probabilities
	for probability in probabilities:
		total_probability += probability
		cumulative_probabilities.append(total_probability)
	
	# Generate a random value between 0 and the total probability
	var random_value: float = randf() * total_probability
	
	# Find the index of the selected probability
	for i in range(cumulative_probabilities.size()):
		if random_value < cumulative_probabilities[i]:
			return i
	
	# If no probability was selected, return the last index
	return probabilities.size() - 1
