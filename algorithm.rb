require_relative "./maze.rb"

def h(coords1, coords2)
	# decide which node is most likely to yield the fastest path
	# the input to this function is heuristic([x1, y1], [x2, y2])
	distancecoords = [coords2[0] - coords1[0], coords2[1] - coords1[1]]
	distance = distancecoords[0].abs() + distancecoords[1].abs()
	return distance.to_f
end

def astar(maze)
	# A* search!

	# pseudo:
	# 1. create list of unvisited nodes with the node, g-score, f-score (non-starting nodes have a starting g- and f-score of infinity)(starting node has a g-score of 0 and f-score of manhattan), and the previously visited node
	# 2. create list of visited nodes with the same header data
	# 3. choose the unvisited node with the lowest g-score

	# terms:
	# => g-score is the cost from the start to that point
	# => f-score is the predicted cost from start to end along that path (g-score + h)

	# flatten maze 2d array to a 1d array for VISITEDNODE association bc im shit at algorithm design
	nodes = []
	maze.maze.each do |row|
		row.each do |node|
			nodes << node
		end
	end

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
	# due to this structure, the initial indexes of the unvisited array are equivilant with their respective node indexes, if thats worth anything whatsoever
	maze.maze.each_with_index do |row, yindex|
		row.each_with_index do |node, xindex|
			if(node.is_starting?)
				# initialize with g-score of 0 and f-score of h
				unvisited << VISITEDNODE.new(node.index, 0.0, h(starting, ending), nil)
			else
				# put enter infinity values
				unvisited << VISITEDNODE.new(node.index, Float::INFINITY, Float::INFINITY, nil)
			end
		end
	end

	traversed = []

	solved = false

	# main loop
	while(!solved)
		# find lowest f-score and make that node the current node
		# for the first iteration, this will always be the starting node because the others are all infinite.
		currentnode = nil
		lowcheck = nil
		unvisited.each do |item|
			if(lowcheck == nil)
				lowcheck = item
			end
			if(item.f_score < lowcheck.f_score)
				lowcheck = item
			end
		end
		currentnode = lowcheck
		currentnodeobj = nodes[currentnode.index]

		# check neighboring nodes for the target
		currentnodeobj.neighbor_list.each do |node|
			if(node.is_ending?)
				solved = true
			end
		end

		# evaluate neighbor nodes for g-scores and f-scores, assign previous node as current node
		# use neighbor obj index to get the NODE from nodes[], then find proper VISITEDNODE and adjust previous node, g-, and f-scores accordingly
		neighbors = []
		# if a neighbor node is in unvisited, evaluate g- and f-scores and add a previous node
		currentnodeobj.neighbor_list.each do |node|
			if(unvisited.include? {|obj| obj[0] == node.index})
				# add to g-score
				obj[1] = currentnode[1] + 1.0
				# evaluate f-score
				obj[2] = obj[1] + h(starting, [currentnodeobj.x, currentnodeobj.y])
				# set previous node
				obj[3] = currentnode[0]
			end
		end
		traversed << currentnode
	end
end







