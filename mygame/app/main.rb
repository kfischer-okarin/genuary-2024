require_relative 'day01'

def tick(args)
  Day01.tick(args)

  args.outputs.labels << { x: 10, y: 710, text: $gtk.current_framerate.to_i.to_s, r: 255, g: 255, b: 255 }
end


$gtk.reset
