require_relative 'day01'

def tick(args)
  if args.tick_count.zero?
    $scenes = (1..31).filter_map do |day|
      Object.const_get("Day%02d" % day) rescue nil
    end
    $scene_index ||= 0
  end

  if args.inputs.keyboard.key_down.left
    $scene_index = ($scene_index - 1) % $scenes.length
    start_scene
  elsif args.inputs.keyboard.key_down.right
    $scene_index = ($scene_index + 1) % $scenes.length
    start_scene
  end

  $scenes[$scene_index].tick(args)

  args.outputs.labels << { x: 10, y: 710, text: $gtk.current_framerate.to_i.to_s }.label!(args.state.text_color || {})
end

def start_scene
  $gtk.reset
  $gtk.notify! $scenes[$scene_index].name
end

$gtk.reset
