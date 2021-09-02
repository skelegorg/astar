# classes for search algorithms

# A* needs to see 

#   0123
# 0 X XX
# 1 X  X
# 2 XX X
# 3 XX X

class NODE
	# node
	def initialize(ind, x, y)
		@index = ind
		@x = x
		@y = y
		@neighbor_list = []
		@visited = false
		@starting = false
		@ending = false
	end
	def index() @index end
	def x() @x end
	def y() @y end
	def neighbor_list() 
		@neighbor_list 
	end
	def neighbor_list=(neighbor_list) 
		@neighbor_list = neighbor_list 
	end
	def to_s()
		if(@starting)
			return "SS"
		elsif(@ending)
			return "EE"
		else
			return "  "
		end
	end
	def starting=(value)
		@starting = value
	end
	def ending=(value)
		@ending = value
	end
	def is_starting?()
		@starting
	end
	def is_ending?()
		@ending
	end
end

class EMPTYNODE
	def initialize(ind, x, y)
		@index = ind
		@x = x
		@y = y
	end
	def index() @index end
	def x() @x end
	def y() @y end
	def to_s()
		return "██"
	end
	def is_starting?() false end
	def is_ending?() false end
	def neighbor_list() nil end
end

class NEIGHBOR
	def initialize(ind, y, x)
		@i = {:index => ind, :x => x, :y => y}
	end

	def i() @i end
end

class VISITEDNODE
	attr_accessor :index, :g_score, :f_score, :previous
	def initialize(ind, g, f, prev)
		@index = ind
		@g_score = g
		@f_score = f
		@previous = prev
	end
	def index
		@index
	end
end

class MAZE
	def initialize(_2darr, startind, endind)
		# creates maze
		@maze = Array.new(_2darr.length) { Array.new(_2darr[0].length) }
		ind = 0
		
		self.maze.each_with_index do |row, yindex|
			row.each_with_index do |node, xindex|
				if(_2darr[yindex][xindex] == 1)
					self.maze[yindex][xindex] = NODE.new(ind, xindex, yindex)
				else
					self.maze[yindex][xindex] = EMPTYNODE.new(ind, xindex, yindex)
				end
				ind += 1
			end
		end
		# populates adjacency index
		self.maze.each_with_index do |row, yindex|
			row.each_with_index do |node, xindex|
				# skip edges but lazily lmao
				neighbor_list = []
				begin
					# check surrounding nodes
					# big if statment of doom
					#   ██    yindex + 1
					# ██████  xindex - 1 xindex + 1
					#   ██    yindex - 1

					if(self.maze[yindex + 1][xindex].is_a?(NODE))
						neighbor_list << NEIGHBOR.new(self.maze[yindex + 1][xindex].index, (yindex + 1), xindex)
					end
					if(self.maze[yindex][xindex - 1].is_a?(NODE))
						neighbor_list << NEIGHBOR.new(self.maze[yindex][xindex - 1].index, yindex, (xindex - 1))
					end
					if(self.maze[yindex][xindex + 1].is_a?(NODE))
						neighbor_list << NEIGHBOR.new(self.maze[yindex][xindex + 1].index, yindex, (xindex + 1))
					end
					if(self.maze[yindex - 1][xindex].is_a?(NODE))
						neighbor_list << NEIGHBOR.new(self.maze[yindex - 1][xindex].index, (yindex - 1), xindex)
					end
				rescue
				ensure
					if(self.maze[yindex][xindex].is_a?(NODE))
						self.maze[yindex][xindex].neighbor_list=(neighbor_list)
					end
				end
			end
		end
		# assign starting and ending nodes
		self.maze.each_with_index do |row, yindex|
			row.each_with_index do |node, xindex|
				begin
					if(self.maze[yindex][xindex].index == startind)
						self.maze[yindex][xindex].starting=(true)
					elsif(self.maze[yindex][xindex].index == endind)
						self.maze[yindex][xindex].ending=(true)
					end
				rescue
					puts "Starting or Ending node cannot be a wall."
					return
				end
			end
		end
	end
	def maze() @maze end
	def print()
		self.maze.each do |row|
			outp = ""
			row.each do |node|
				outp += node.to_s
			end
			puts outp
		end
	end
end