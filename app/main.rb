require 'app/sprites.rb'
require 'app/vector.rb'
# require 'app/grid.rb'

def tick(args)
  args.state.sprites ||= []
  # args.state.grid ||= Grid.new(9)
  args.state.size ||= 64
  $new_sprites = []

  # args.state.grid.cells.each(&:clear)

  args.state.sprites.reject! {|sprite| sprite.delete == true}

  args.state.sprites.each do |sprite|
    sprite.move_direction
    # update_grid(args.state.grid, sprite)
    sprite.collide(args.state.sprites - [sprite])
    args.outputs.sprites << sprite
  end

  $new_sprites.each do |sprite|
    args.state.sprites << sprite
  end

  if args.tick_count % 5 == 0
    if args.inputs.mouse.button_left
      args.state.sprites << Rock.new(x: (60..1220).to_a.sample, y: (60..660).to_a.sample, w: args.state.size, h: args.state.size)
      args.state.sprites << Paper.new(x: (60..1220).to_a.sample, y: (60..660).to_a.sample, w: args.state.size, h: args.state.size)
      args.state.sprites << Scissors.new(x: (60..1220).to_a.sample, y: (60..660).to_a.sample, w: args.state.size, h: args.state.size)
    end
  end

  if args.inputs.mouse.button_right
    args.state.sprites = []
  end

  if args.inputs.mouse.wheel
    args.state.size += args.inputs.mouse.wheel.y
    args.state.sprites.each do |sprite|
      sprite.w = args.state.size
      sprite.h = args.state.size
    end
  end

  # args.state.grid.cells.each do |cell|
  #   args.outputs.borders << [cell.x, cell.y, cell.w, cell.h]
  # end
end

# def update_grid(grid, sprite)
#   sprite.grid_cells = []
#   grid.cells.each do |cell|
#     if cell.contains_sprite?(sprite)
#       cell.sprites << sprite
#       sprite.grid_cells << cell
#     end
#   end
# end



