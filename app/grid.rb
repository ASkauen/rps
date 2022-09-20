class Grid
  attr_accessor :cells

  def initialize(width)
    @res_w = 1280
    @res_h = 720
    @width = width
    @cells = create_cells
  end

  def create_cells
    cols = (0..@res_w).to_a.each_slice( (@res_w/@width.to_f).round ).to_a
    rows = (0..@res_h).to_a.each_slice( (@res_h/@width.to_f).round ).to_a
    cells = []
    cols.each do |col|
      rows.each do |row|
        cells << Cell.new(x: col[0], y: row[0], w: col.size, h: row.size)
      end
    end
    cells
  end
end

class Cell
  attr_accessor :x, :y, :w, :h, :sprites
  def initialize(x:, y:, w:, h:)
    @x = x
    @y = y
    @w = w
    @h = h
    @sprites = []
  end
  
  def contains_sprite?(sprite)
    return false if @x > (sprite.x + sprite.w) || (@x + @w) < sprite.x || @y > (sprite.y + sprite.h) || (@y + @h) < sprite.y
    true
  end
  
  def clear
    @sprites = []
  end
end