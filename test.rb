require "./cell"
require "./maze"

maze = Maze.new(nx: 30, ny: 20, ix: 0, iy: 0)
maze.create
maze.write_svg('maze.svg')
maze.print
