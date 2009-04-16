#
#  ns_image_monkey_patches.rb
#  Thumber
#
#  Created by Ben Sandofsky on 4/15/09.
#  Copyright (c) 2009 Ben Sandofsky. All rights reserved.
#

# Credit goes to: http://www.rubycocoa.com/cocoa-magic-for-gruff-graphs/2/
class NSImage

  def writeJPEG(filename)
    bits = NSBitmapImageRep.alloc.initWithData(self.TIFFRepresentation)
    data = bits.representationUsingType(NSJPEGFileType, :properties => nil)
    data.writeToFile filename, :atomically => false
  end

  def copyAndScale(factor)
    newWidth, newHeight = size.width*factor, size.height*factor
    newImage = NSImage.alloc.initWithSize [newWidth, newHeight]
    newImage.lockFocus
    drawInRect [0, 0, newWidth, newHeight],
      :fromRect => [0, 0, size.width, size.height],
      :operation => NSCompositeSourceOver,
      :fraction => 1.0
    newImage.unlockFocus
    newImage
  end
  
  def resizeTo(x, y)
    newWidth, newHeight = x, y
    newImage = NSImage.alloc.initWithSize [newWidth, newHeight]
    newImage.lockFocus
    drawInRect [0, 0, newWidth, newHeight], :fromRect => [0, 0, size.width, size.height],
    :operation => NSCompositeSourceOver, :fraction => 1.0
    newImage.unlockFocus
    newImage
  end
end
