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

	pairs = []
	pair = Struct.new(:v, :obj)

	unvisited = []
	# for array index association
	unvisitedgrid = []
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
			# the program can only travel to nodes, no need to create objects for walls.
			if(node.is_a? NODE)
				if(node.is_starting?)
					# initialize with g-score of 0 and f-score of h
					nowde = pair.new(VISITEDNODE.new(node.index, 0.0, h(starting, ending), nil), nodes[node.index])
					unvisited << nowde
					unvisitedgrid << nowde
				else
					# put enter infinity values
					nowde = pair.new(VISITEDNODE.new(node.index, Float::INFINITY, Float::INFINITY, nil), nodes[node.index])
					unvisited << nowde
					unvisitedgrid << nowde
				end
			else
				unvisitedgrid << nil
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
				lowcheck = item.v
			end
			if(item.v.f_score < lowcheck.f_score)
				lowcheck = item.v
			end
		end
		currentnode = lowcheck
		currentitem = nil
		unvisited.each do |item|
			if(item.obj.index == lowcheck.index)
				currentitem = item
			end
		end
		# currentitem = unvisited[lowcheck.index]
		currentnodeobj = currentitem.obj

		# check neighboring nodes for the target
		currentnodeobj.neighbor_list.each do |node|
			if(nodes[node.i[:index]].is_ending?)
				solved = true
			end
		end

		# evaluate neighbor nodes for g-scores and f-scores, assign previous node as current node
		# use neighbor obj index to get the NODE from nodes[], then find proper VISITEDNODE and adjust previous node, g-, and f-scores accordingly
		# if a neighbor node is in unvisited, evaluate g- and f-scores and add a previous node
		currentnodeobj.neighbor_list.each do |node|
			if(unvisited.any? {|obj| obj.v.index == node.i[:index]})
				unvisited.each_with_index do |obj, index|
					if (obj.v.index == node.i[:index])
						# add to g-score
						unvisited[index].v.g_score = currentnode.g_score + 1.0
						# evaluate f-score
						unvisited[index].v.f_score = unvisited[index].v.g_score + h(starting, [currentnodeobj.x, currentnodeobj.y])
						# set previous node
						unvisited[index].v.previous = currentnode.index
					end
				end
			end
		end
		traversed << currentnode
		visited << currentitem
		unvisited.delete(currentitem)
	end
	# traverse visited list backwards, linking the nodes it took together
	path = []
	foundstart = false
	curnode = visited[-1]
	while(!foundstart)
		# start at last node, track the previous node all the way back to the beginning
		path << curnode
		if(curnode.obj.is_starting?)
			foundstart = true
		end
		sindex = curnode.v.previous
		visited.each do |item|
			if(item.v.index == sindex)
				curnode = item
			end
		end
	end
	path.reverse()
	path
end