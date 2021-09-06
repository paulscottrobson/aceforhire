# *****************************************************************************
# *****************************************************************************
#
#		Name:		window.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		6th September 2021
#		Reviewed: 	No
#		Purpose:	Draw all airports in a window.
#
# *****************************************************************************
# *****************************************************************************

require "ruby2d"
require "./airportdb.rb"

# *****************************************************************************
#
#  							Very simple map drawer
#
# *****************************************************************************

class Map_Display 
	def initialize(data_set) 
		@image = Image.new("../airports/map.jpg")
		@width = @image.width
		@height = @image.height
		Window.set background:"green",title:"Route map"
		Window.on :key do |e| Window.close end
		Window.set width:@width,height:@height
		calculate_window data_set
		redo_image
	end 
	#
	# 		Calculate range of display window.
	#
	def calculate_window(ds)
		@a_min = { x:99,y:99 } 													# calculate extent
		@a_max = { x:-99,y:-99 }
		ds.each do |apt|
			@a_min[:x] = [@a_min[:x],apt[:x]].min
			@a_max[:x] = [@a_max[:x],apt[:x]].max
			@a_min[:y] = [@a_min[:y],apt[:y]].min
			@a_max[:y] = [@a_max[:y],apt[:y]].max
		end
		@a_centre = {  															# calculate centre.
			x: (@a_min[:x]+@a_max[:x])/2,
			y: (@a_min[:y]+@a_max[:y])/2
		}
		@w_centre = calculate_position @a_centre 								# convert centre to position on image
		#
		w_min = calculate_position @a_min 										# convert range to position on image.
		w_max = calculate_position @a_max
		scale_x = (@width/(w_max[:x]-w_min[:x])).abs  							# scalars for x and y
		scale_y = (@height/(w_max[:y]-w_min[:y])).abs  					
		@scale = [[scale_x,scale_y].min*0.95,4].min  							# scale image by @scale
	end
	#
	#  		Position to one on the image when not scaled/zoomed.
	#
	def calculate_position(p)
		x = p[:x] * @width
		y = @height / 2 - p[:y] * @height * 1.00
		{ x:x,y:y }
	end
	#
	# 		Convert airport position to coordinate.
	#
	def calculate_airport_display_position(air)
		ip = calculate_position(air) 											# position
		ip[:x] = ip[:x] - @w_centre[:x]											# offset from centre point
		ip[:y] = ip[:y] - @w_centre[:y]
		ip[:x] = ip[:x] * @scale  												# scale up
		ip[:y] = ip[:y] * @scale
		ip[:x] = ip[:x] + @width/2												# and offset back
		ip[:y] = ip[:y] + @height/2
		ip
	end
	#
	# 		Draw an airport data
	#
	def draw_airport(air)
		p = calculate_airport_display_position air 
		Circle.new(x:p[:x],y:p[:y],radius:8,color:"white")
		Circle.new(x:p[:x],y:p[:y],radius:6,color:"red")
		p
	end
	#
	# 		Draw a flight 
	#
	def draw_flight(air1,air2)
		c1 = draw_airport(air1)
		c2 = draw_airport(air2)
		Line.new(x1:c1[:x],y1:c1[:y],x2:c2[:x],y2:c2[:y],width:3,color:"yellow")
	end
	#
	# 		Rescale and reposition image
	#
	def redo_image 
		@image.width = @width * @scale 
		@image.height = @height * @scale
		@image.x = @width/2-@w_centre[:x]*@scale
		@image.y = @height/2-@w_centre[:y]*@scale
	end
	#
	def display
		Window.show
	end
end

if __FILE__ == $0 

	data = Airport_Database.new.get
	displayData = [ data["EGPD"],data["LEMG"],data["EIDW"],data["EGJJ"],data["EDDM"]]

	#displayData.append(data["YSSY"])

	#displayData = data.collect { |key,value| value }

	md = Map_Display.new(displayData)
	displayData.each do |apt|
		md.draw_airport apt
	end
	md.draw_flight(data["EDDM"],data["YSSY"])
	md.display

end