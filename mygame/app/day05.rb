module Day05
  class << self
    def tick(args)
      args.state.text_color ||= { r: 255, g: 255, b: 255 }
      if args.state.tick_count.zero?
        grid_w = 14
        grid_h = 8
        dx = 1280 / grid_w
        dy = 720 / grid_h
        args.state.centers = grid_w.times.flat_map do |x|
          grid_h.times.map do |y|
            { x: dx * x + dx / 2, y: dy * y + dy / 2 }
          end
        end
      end
      2.times do
        args.state.indexes ||= [].tap { |indexes|
          args.state.centers.size.times { |i|
            indexes.concat(10.times.map { |j| [i, j] })
          }
        }.shuffle
        args.state.rects ||= {}

        args.outputs.background_color = [0, 0, 0]
        next_index = args.state.indexes.shift
        if next_index
          index, rect_index = next_index
          center = args.state.centers[index]
          size = (rect_index * 10) + 10
          args.state.rects[next_index] = build_rect(center[:x], center[:y], size)
        else
          args.state.indexes = nil
        end
      end
      args.outputs.lines << args.state.rects.values
    end

    def build_rect(x, y, size)
      half_size = size / 2
      quarter_size = size / 4
      top_left = { x: x - half_size + (rand * quarter_size), y: y + half_size - (rand * quarter_size) }
      top_right = { x: x + half_size - (rand * quarter_size), y: y + half_size - (rand * quarter_size) }
      bottom_left = { x: x - half_size + (rand * quarter_size), y: y - half_size + (rand * quarter_size) }
      bottom_right = { x: x + half_size - (rand * quarter_size), y: y - half_size + (rand * quarter_size) }
      r = rand(255)
      g = rand(255)
      b = rand(255)
      [
        { x: top_left[:x], y: top_left[:y], x2: top_right[:x], y2: top_right[:y], r: r, g: g, b: b },
        { x: top_right[:x], y: top_right[:y], x2: bottom_right[:x], y2: bottom_right[:y], r: r, g: g, b: b },
        { x: bottom_right[:x], y: bottom_right[:y], x2: bottom_left[:x], y2: bottom_left[:y], r: r, g: g, b: b },
        { x: bottom_left[:x], y: bottom_left[:y], x2: top_left[:x], y2: top_left[:y], r: r, g: g, b: b },
      ]
    end
  end
end

$gtk.reset
