# A* search!

# include maze class and related classes
require_relative './maze.rb'
# include A* algorithm
require_relative './algorithm.rb'

# 0 is a wall, 1 is a traversable node
# add as many rows and columns as you want, but be sure to
# adjust the x and y size bounds in the MAZE.new declaration.
mazetemplate = [
	[0, 0, 0, 1, 0, 0, 0, 0],
	[0, 1, 1, 1, 1, 1, 1, 0],
	[0, 0, 1, 0, 0, 0, 1, 0],
	[0, 1, 1, 1, 1, 1, 1, 0],
	[0, 1, 0, 0, 0, 1, 0, 0],
	[0, 1, 1, 0, 1, 1, 0, 0],
	[0, 0, 1, 1, 1, 0, 0, 0],
	[0, 0, 1, 0, 0, 0, 0, 0]
]

maze = MAZE.new(mazetemplate, 3, 58)

# puts maze.maze[1][2].neighbor_list[0].i[:index]

# puts "Key:\nSS: starting node\nEE: ending node\n██: wall (not traversable)\n "

maze.maze.each do |row|
	outp = ""
	row.each do |node|
		outp += node.to_s
	end
	puts outp
end

astar(maze)