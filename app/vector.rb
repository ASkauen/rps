class Vector
  attr_accessor :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  NORMALS = {
    left: {x: -1, y: 0},
    right: {x: 1, y: 0},
    top: {x: 0, y: -1},
    bottom: {x: 0, y: 1}
  }

  def self.random
    Vector.new(x: (-100..100).to_a.sample, y: (-100..100).to_a.sample).normalize
  end

  def dot(vector)
    (@x * vector.x) + (@y * vector.y)
  end

  def normalize
    length = Math.sqrt(@x**2 + @y**2)
    @x /= length
    @y /= length
    self
  end

  def reflect(normal)
    dn = 2 * dot(normal)
    dn_normal = Vector.new(x: normal.x * dn, y: normal.y * dn)
    Vector.new(x: @x - dn_normal.x, y: @y - dn_normal.y).normalize
  end
end