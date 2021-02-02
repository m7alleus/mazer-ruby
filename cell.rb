class Cell
  # A cell in the maze.

  # A maze "Cell" is a point in the grid which may be surrounded by walls to
  # the north, east, south or west.

  attr_reader :x, :y
  attr_accessor :walls

  # A wall separates a pair of cells in the N-S or W-E directions.
  WALL_PAIRS = {
    N: :S,
    S: :N,
    E: :W,
    W: :E,
  }

  def initialize(x, y)
    # Initialize the cell at (x,y). At first it is surrounded by walls.
    @x = x
    @y = y
    @walls = {
      N: true,
      S: true,
      E: true,
      W: true,
    }
  end

  def all_walls?
    # Does this cell still have all its walls?
    walls.values.all?
  end

  def knock_down_wall(other_cell, wall)
    # Knock down the wall between cells self and other.
    walls[wall] = false
    other_cell.walls[WALL_PAIRS[wall]] = false
  end

  # to ease debug
  def print
    str =
      if all_walls?
        [
          "+-+",
          "| |",
          "+-+",
        ]
      elsif walls.values.none?
        [
          "+ +",
          "   ",
          "+ +",
        ]
      elsif walls[:N] && walls[:E] && walls[:S]
        [
          "+-+",
          "  |",
          "+-+",
        ]
      elsif walls[:E] && walls[:S] && walls[:W]
        [
          "+ +",
          "| |",
          "+-+",
        ]
      elsif walls[:N] && walls[:W] && walls[:S]
        [
          "+-+",
          "|  ",
          "+-+",
        ]
      elsif walls[:N] && walls[:E] && walls[:W]
        [
          "+-+",
          "| |",
          "+ +",
        ]
      elsif walls[:N] && walls[:S]
        [
          "+-+",
          "   ",
          "+-+",
        ]
      elsif walls[:E] && walls[:W]
        [
          "+ +",
          "| |",
          "+ +",
        ]
      elsif walls[:N] && walls[:E]
        [
          "+-+",
          "  |",
          "+ +",
        ]
      elsif walls[:N] && walls[:W]
        [
          "+-+",
          "|  ",
          "+ +",
        ]
      elsif walls[:S] && walls[:E]
        [
          "+ +",
          "  |",
          "+-+",
        ]
      elsif walls[:S] && walls[:W]
        [
          "+ +",
          "|  ",
          "+-+",
        ]
      elsif walls[:N]
        [
          "+-+",
          "   ",
          "+ +",
        ]
      elsif walls[:E]
        [
          "+ +",
          "  |",
          "+ +",
        ]
      elsif walls[:S]
        [
          "+ +",
          "   ",
          "+-+",
        ]
      elsif walls[:W]
        [
          "+ +",
          "|  ",
          "+ +",
        ]
      end

    str.map { |r| puts r }
    nil
  end

end
