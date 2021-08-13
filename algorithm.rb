def h(coords1, coords2)
	# decide which node is most likely to yield the fastest path
	# the input to this function is heuristic([x1, y1], [x2, y2])
	distancecoords = [coords2[0] - coords1[0], coords2[1] - coords1[1]]
	distance = distancecoords[0].abs() + distancecoords[1].abs()
	distance
end

def astar(maze)
	# A* search!

	# pseudo:
	# 1. create list of unvisited nodes with the node, g-score, f-score (non-starting nodes have a starting g- and f-score of infinity)(starting node has a g-score of 0 and f-score of manhattan), and the previously visited node
	# 2. create list of visited nodes with the same header data
	# 3. choose the unvisited node with the lowest g-score

	unvisited = []
	visited = []

	# find ending and starting nodes
	ending = nil
	starting = nil

	maze.maze.each do |row|
		row.each do |node|
			if(node.is_ending?)
				ending = [node.x, node.y]
			end
			if(node.is_starting?)
				starting = [node.x, node.y]
			end
		end
	end

	if(ending == nil || starting == nil)
		return "Missing a starting or ending node"
	end

	# initialize unvisited with all nodes besides the starting node
	maze.maze.each_with_index do |row, yindex|
		row.each_with_index do |node, xindex|
			if(node.is_starting?)
				# initialize with g-score of 0 and f-score of h
				unvisited << [node.index, 0, h(starting, ending), nil]
			end
		end
	end
end