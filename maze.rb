require "pry"

class Maze
  # A Maze, represented as a grid of cells.

  attr_reader :cells, :nx, :ny, :ix, :iy

  def initialize(nx:, ny:, ix: 0, iy: 0)
    # The maze consists of nx x ny cells and will be constructed starting
    # at the cell indexed at (ix, iy).
    @nx = nx
    @ny = ny
    @ix = ix
    @iy = iy
    @cells =
      nx.times.map do |x|
        ny.times.map do |y|
          Cell.new(x, y)
        end
      end
  end

  def cell_at(x, y)
    # Return the Cell object at (x,y).
    cells[x][y]
  end

  def print
    # Return a (crude) string representation of the maze.
    maze_rows = ["-" * nx * 2]
    ny.times do |y|
      maze_row = ["|"]
      nx.times do |x|
        if cells[x][y].walls[:E]
          maze_row << " |"
        else
          maze_row << "  "
        end
      end
      maze_rows << maze_row.join("")

      maze_row = ["|"]
      nx.times do |x|
        if cells[x][y].walls[:S]
          maze_row << "-+"
        else
          maze_row << " +"
        end
      end
      maze_rows << maze_row.join("")
    end

    maze_rows.map { |r| puts r }
    nil
  end

  def find_unvisited_neighbours(cell)
    # Return a list of unvisited neighbours to cell.
    delta = {
      "W": [-1, 0],
      "E": [1, 0],
      "S": [0, 1],
      "N": [0, -1],
    }

    neighbours = []
    delta.each do |direction, (dx, dy)|
      x2 = cell.x + dx
      y2 = cell.y + dy

      if (0 <= x2 && x2 < nx) && (0 <= y2 && y2 < ny)
        neighbour = cells[x2][y2]
        neighbours << [direction, neighbour] if neighbour.all_walls?
      end
    end

    neighbours
  end

  def create
    # Total number of cells.
    n = nx * ny
    cell_stack = []
    current_cell = cells[ix][iy]

    # Total number of visited cells during maze construction.
    nv = 1
    while nv < n do
      neighbours = find_unvisited_neighbours(current_cell)

      if neighbours.empty?
        # We"ve reached a dead end: backtrack.
        current_cell = cell_stack.pop
        next
      end
      # Choose a random neighbouring cell and move to it.
      direction, next_cell = neighbours.sample
      current_cell.knock_down_wall(next_cell, direction)
      cell_stack << current_cell
      current_cell = next_cell
      nv += 1
    end
  end

  def write_svg(filename)
    # Write an SVG image of the maze to filename.

    aspect_ratio = nx / ny
    # Pad the maze all around by this amount.
    padding = 10
    # Height and width of the maze image (excluding padding), in pixels
    height = 500
    width = height * aspect_ratio
    # Scaling factors mapping maze coordinates to image coordinates
    scy, scx = height / ny, width / nx

    # Write the SVG image file for maze
    file = File.new(filename, "w")

    # SVG preamble and styles.
    file.puts("<?xml version='1.0' encoding='utf-8'?>")
    file.puts("<svg xmlns='http://www.w3.org/2000/svg'")
    file.puts("    xmlns:xlink='http://www.w3.org/1999/xlink'")
    file.puts("    width='#{width + 2 * padding}' height='#{height + 2 * padding}' viewBox='#{-padding} #{-padding} #{width + 2 * padding} #{height + 2 * padding}'>")
    file.puts("<defs>\n<style type='text/css'><![CDATA[")
    file.puts("line {")
    file.puts("    stroke: #000000;\n    stroke-linecap: square;")
    file.puts("    stroke-width: 5;\n}")
    file.puts("]]></style>\n</defs>")
    # Draw the "South" and "East" walls of each cell, if present (these
    # are the "North" and "West" walls of a neighbouring cell in
    # general, of course).
    nx.times do |x|
      ny.times do |y|
        if cells[x][y].walls[:S]
          x1 = x * scx
          y1 = (y + 1) * scy
          x2 = (x + 1) * scx
          y2 = (y + 1) * scy
          file.puts("<line x1='#{x1}' y1='#{y1}' x2='#{x2}' y2='#{y2}'/>")
        end
        if cells[x][y].walls[:E]
          x1 = (x + 1) * scx
          y1 = y * scy
          x2 = (x + 1) * scx
          y2 = (y + 1) * scy
          file.puts("<line x1='#{x1}' y1='#{y1}' x2='#{x2}' y2='#{y2}'/>")
        end
      end
    end

    # Draw the North and West maze border, which won"t have been drawn
    # by the procedure above.
    file.puts("<line x1='0' y1='0' x2='#{width}' y2='0'/>")
    file.puts("<line x1='0' y1='0' x2='0' y2='#{height}'/>")
    file.puts("</svg>")

    file.close
  end

end
