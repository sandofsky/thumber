#
#  image_processor.rb
#  Thumber
#
#  Created by Ben Sandofsky on 4/15/09.
#  Copyright (c) 2009 Ben Sandofsky. All rights reserved.
#

class ImageProcessor
  def initialize(options = {})
    @options = options
  end
	
  def main
#  	QTTime time = QTMakeTime([mFrameCount longLongValue], [mScale longValue]);
#    NSError *err = [[NSError alloc] init];
#    NSSize size;
#    size.width = [mWidth floatValue];
#    size.height = [mHeight floatValue];
#    NSValue *value = [NSValue valueWithSize:size];
#    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: value, @"QTMovieFrameImageSize", nil];
#    NSRect rect;
#    rect.size = size;
#    NSImage *image = [mMovie frameImageAtTime:time withAttributes:attributes error:&err];
#    [image drawAtPoint:mPoint fromRect:rect operation:NSCompositeSourceOver fraction:1.0];
  end
end
