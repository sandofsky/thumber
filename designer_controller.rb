#
#  designer_controller.rb
#  Thumber
#
#  Created by Ben Sandofsky on 4/15/09.
#  Copyright (c) 2009 Ben Sandofsy. All rights reserved.
#

class DesignerController
	attr_accessor :source_file
	attr_accessor :output_file
	attr_accessor :output_file_button
	attr_accessor :window
	attr_accessor :go_button
	attr_accessor :progress
	attr_accessor :thumb_size_control
	attr_accessor :column_control
	attr_accessor :interval_control
	attr_accessor :movie_view
	attr_accessor :maintain_square_control
	attr_accessor :thumb_y_size_control
	attr_accessor :row_control
	attr_accessor :finalXControl
	attr_accessor :finalYControl
	
	def recalculateSettings(sender)
    # Width Control
		update_y_control_size!
		
		#Figure out total frames
		update_frame_count!
			
		# Columns
		update_rows_count!
				
		@finalXControl.setIntValue(thumb_x_size * columns)
		@finalYControl.setIntValue(thumb_y_size * rows)
		
		thumb_size = @thumb_size_control.floatValue.to_i
			maintain_square = true # TODO: pull from UI
			if maintain_square
			  thumb_y_size = thumb_x_size = thumb_size
		  else
			# calculate y 
		end
	end
	
  def finalX
    @finalXControl.intValue
  end
  
  def finalY
    @finalYControl.intValue
  end
  
  def rows
    @row_control.intValue
  end
  
  def update_rows_count!
    @column_control.setIntValue 1 if @column_control.intValue == 0
    # We add an extra row to account for remainder frames.
    @row_control.setIntValue((@frame_count / @column_control.intValue) + 1)
  end
  
  def update_y_control_size!
    @thumb_size_control.setIntValue 1 if @thumb_size_control.intValue == 0
    y = if @maintain_square_control.state == OSX::NSOnState
      @thumb_size_control.intValue
    else
      @thumb_size_control.intValue / @ratio
    end
    @thumb_y_size_control.setIntValue(y)
  end
  
  def pickDestination
    panel = OSX::NSSavePanel.savePanel
    panel.setAllowedFileTypes(['jpg', 'jpeg', 'tif', 'tiff'])
    panel.setAllowsOtherFileTypes(true)
    panel.setCanSelectHiddenExtension(true)
    dir = @output_file.stringValue.split('/')
    file = dir.pop
    clicked = panel.runModalForDirectory_file(dir.join('/'), file)
    if clicked == OSX::NSOKButton
      @output_file.setStringValue panel.filename
    end
  end
	
	def process
	@go_button.setEnabled(false)
	@go_button.displayIfNeeded
		raise unless @output_file.stringValue && @source_file.stringValue
		raise if @source_file.stringValue == @output_file.stringValue
    @output = OSX::NSImage.alloc.initWithSize([finalX, finalY])
    @output.lockFocus
    OSX::NSColor.blackColor.set
    OSX::NSRectFill([0,0, finalX, finalY])
    #full_sized_rect = [0, 0, @movie.currentFrameImage.size.width, @movie.currentFrameImage.size.height]
	full_sized_rect = [0, 0, thumb_x_size, thumb_x_size]
    ::Profiler__::start_profile if PROFILE
    (0..@movie.duration.timeValue).step(timescale * interval) do |current_frame|
      @progress.incrementBy(increment_value)
      @progress.displayIfNeeded
      i = current_frame / timescale
      column = (i / interval).to_i % columns
      row = (i / interval).to_i / columns
      x = column * thumb_x_size
      y = finalY - ((row + 1) * thumb_y_size)
	  point = OSX::NSPoint.new(x,y)
	  operation = OSX::THImageProcessor.alloc.initWithFrameCount_scale_width_height_point_movie(current_frame, @timescale, thumb_x_size, thumb_y_size, point, @movie)
	  operation.main
    end
    ::Profiler__::stop_profile if PROFILE
    ::Profiler__::print_profile($stderr) if PROFILE
    @output.unlockFocus
    @output.writeJPEG(@output_file.stringValue)
    @progress.setDoubleValue(0.00)
	@go_button.setEnabled(true)
	end
  
  	COLUMNS = 60
	DEFAULT_X = 32
	
	def pickSource
    panel = OSX::NSOpenPanel.openPanel
    clicked = panel.runModalForDirectory_file_types(nil, nil, ['mov', 'm4v', 'mp4'])
    if clicked == OSX::NSOKButton
      filename = panel.filenames.to_a.first
      @source_file.setStringValue filename
      out = filename.split('.')
      out[-1] = 'jpg'
      @output_file.setStringValue out.join('.')
      @movie = OSX::QTMovie.movieWithFile_error(@source_file.stringValue, nil)
      enableControls!
      populateSettings!
    end
  end
  
  def enableControls!
    [@thumb_size_control, @interval_control, @maintain_square_control,
     @column_control, @output_file_button, @go_button].each {|c| c.setEnabled(true) }
    @go_button.highlight(true)
  end
  
  def populateSettings!
    # Pull the first image
    @timescale = @movie.duration.timeScale
    frame = @movie.frameImageAtTime(OSX::QTTime.new(0, @timescale, 0))
    @movie_x = frame.size.width
    @movie_y = frame.size.height
    @ratio = @movie_x / @movie_y
    @thumb_size_control.setIntValue(DEFAULT_X)
    recalculateSettings
  end
  
  def timescale
    @timescale
  end
  
  def increment_value
    100.0 / @frame_count
  end
  
  def interval
    @interval_control.floatValue
  end
  
  def update_frame_count!
    # Calculated how many frames we'll grab
    @frame_count = (@movie.duration.timeValue / @movie.duration.timeScale / interval).to_i
  end
  
  def columns
    @column_control.intValue
  end
  
  def thumb_x_size
    @thumb_size_control.intValue
  end
  
  def thumb_y_size
    @thumb_y_size_control.intValue
  end
  
end
