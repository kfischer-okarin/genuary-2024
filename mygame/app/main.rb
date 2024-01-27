def tick(args)
  args.outputs.background_color = [0, 0, 0]
  args.state.water_base_y ||= 500
  args.state.water_points ||= 129.times.map { |k|
    { x: 10 * k, y: args.state.water_base_y, f_y: 0 }
  }
  args.state.bubbles ||= []

  if args.inputs.mouse.held
    args.state.water_points.each do |p|
      p[:f_y] += 20 if p[:x] > args.inputs.mouse.x - 10 && p[:x] < args.inputs.mouse.x + 10
    end
  end

  water_base_y = args.state.water_base_y
  water_points = args.state.water_points
  water_point_count = water_points.length

  water_points.each_with_index do |p, i|
    p[:f_y] -= (p[:y] - water_base_y) / 10
    left_p_y = i > 0 ? water_points[i - 1][:y] : water_base_y
    right_p_y = i < water_point_count - 1 ? water_points[i + 1][:y] : water_base_y
    mean_y = (left_p_y + right_p_y) / 2
    p[:f_y] -= (p[:y] - mean_y) / 10
    p[:f_y] *= 0.9

    p[:y] += p[:f_y]
    if (p[:y] - args.state.water_base_y).abs < 1
      p[:f_y] = 0
      p[:y] = args.state.water_base_y
    end
  end

  args.state.water_points.each_cons(2) do |p1, p2|
    args.outputs.lines << p1.merge(x2: p2[:x], y2: p2[:y], r: 100, g: 100, b: 255)
  end

  args.outputs.sprites << args.state.bubbles.map { |bubble|
    w = bubble[:w]
    h = bubble[:h]
    { x: bubble[:x] - (w / 2), y: bubble[:y] - (h / 2), w: w, h: h, path: 'sprites/bubble.png' }
  }

  args.outputs.labels << { x: 10, y: 710, text: $gtk.current_framerate.to_i.to_s, r: 255, g: 255, b: 255 }
end

$gtk.reset
