#
#  image_processor.rb
#  Thumber
#
#  Created by Ben Sandofsky on 4/15/09.
#  Copyright (c) 2009 Ben Sandofsky. All rights reserved.
#

class ImageProcessor
  # movie, frame_number, time_scale, width, height, at
  attr_accessor :options
  def initialize(options = {})
    @options = options
  end
	
  def main
    puts "Processing: #{@options[:frame_number]}"
    time = QTMakeTime(@options[:frame_number].longLongValue, @options[:time_scale].longValue)
    size = NSSize.new
    size.width = options[:width].floatValue
    size.height = options[:height].floatValue
    value = NSValue.valueWithSize(size)
    attributes = {"QTMovieFrameImageSize" => value}
    rect = NSRect.new
    rect.size = size
    image = @options[:movie].frameImageAtTime time #, :withAttributes => NSDictionary.dictionaryWithDictionary(attributes), :error => nil
# We would rather run this than resize in a seperate operation,
# but we get errors if we call using the withAttributes.
#    image.drawAtPoint @options[:at], :fromRect => rect, :operation => NSCompositeSourceOver, :fraction => 1.0
    rect.origin = @options[:at]
    fromRect = NSRect.new
    fromRect.size = image.size
    image.drawInRect rect, :fromRect => fromRect, :operation => NSCompositeSourceOver, :fraction => 1.0
  end
end
