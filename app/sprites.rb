class Sprite
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b,
                :source_x, :source_y, :source_w, :source_h,
                :tile_x, :tile_y, :tile_w, :tile_h,
                :flip_horizontally, :flip_vertically,
                :angle_anchor_x, :angle_anchor_y, :blendmode_enum,
                :direction, :delete, :collide, :grid_cells

  def initialize(opts)
    @w = opts[:w]
    @h = opts[:h]
    @x = opts[:x]
    @y = opts[:y]
    @speed = 4
    @direction = direction || Vector.random
    @delete = false
    @grid_cells = []
  end

  def primitive_marker
    :sprite
  end

  def collide(sprites)
    sprites.each do |sprite|
      if touching?(sprite)
        push_out(relative_normal(sprite))
        collide_with(sprite)
      end
    end
  end

  def touching?(sprite)
    return false if self.x > (sprite.x + sprite.w) || (self.x + self.w) < sprite.x || self.y > (sprite.y + sprite.h) || (self.y + self.h) < sprite.y
    true
  end

  def move_direction
    check_wall_hit
    self.x += @direction.x * @speed
    self.y += @direction.y * @speed
  end

  def check_wall_hit
    wall = wall_hit
    if wall
      push_out_of_wall(wall)
      set_direction(@direction.reflect(Vector::NORMALS[wall]))
    end
  end

  def push_out(normal, reverse: false)
    if reverse
      @x += normal.x
      @y += normal.y
    else
      @x -= normal.x
      @y -= normal.y
    end
  end

  def push_out_of_wall(wall)
    x = wall == :left ? 0 : wall == :right ? 1280 : @x
    y = wall == :bottom ? 0 : wall == :top ? 720 : @y
    push_out(relative_normal(Vector.new(x: x, y: y)), reverse: x == 0 || y == 0)
  end

  def collide_with(sprite)
    set_direction(@direction.reflect(relative_normal(sprite)))
    if convert?(sprite.class)
      index = $sprites.index(self)
      return if index.nil?

      $sprites[index] = sprite.class.new(x: @x, y: @y, w: @w, h: @h, direction: @direction)
      $sounds << "sounds/#{sprite.class.name.downcase}.wav"
    end
  end

  def relative_normal(vector)
    Vector.new(x: vector.x - @x, y: vector.y - @y).normalize
  end

  def set_direction(vector)
    @direction = vector.normalize
  end

  def wall_hit
    if self.x <= 0
      :left
    elsif self.x + self.w >= 1280
      :right
    elsif self.y <= 0
      :bottom
    elsif self.y + self.h >= 720
      :top
    else
      false
    end
  end
end

class Rock < Sprite
  def initialize(opts)
    super(opts)
    @path = "sprites/rock.png"
  end

  def convert?(klass)
    klass == Paper
  end
end

class Paper < Sprite
  def initialize(opts)
    super(opts)
    @path = "sprites/paper.png"
  end

  def convert?(klass)
    klass == Scissors
  end
end

class Scissors < Sprite
  def initialize(opts)
    super(opts)
    @path = "sprites/scissors.png"
  end

  def convert?(klass)
    klass == Rock
  end
end