# *****************************************************************************
# *****************************************************************************
#
#		Name:		showairports.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		5th September 2021
#		Reviewed: 	No
#		Purpose:	Draw all airports on image.
#
# *****************************************************************************
# *****************************************************************************

require "ruby2d"
require "./process.rb"

# *****************************************************************************
#
#  							Very simple map drawer
#
# *****************************************************************************

class Map_Display 
	def initialize(scale = 100) 
		@image = Image.new("map.jpg")
		@width = @image.width * scale / 100
		@height = @image.height * scale / 100
		@scale = scale
		Window.set width:@width,height:@height
		Window.set background:"green",title:"Route map"
		@image.width = @width
		@image.height = @height
		ctr = [@width/2,@height/2]
		Line.new(x1:ctr[0]*scale/100,x2:ctr[0]*scale/100,y1:0,y2:@width,color:"white")
		Line.new(x1:0,x2:@height,y1:ctr[1]*scale/100,y2:ctr[1]*scale/100,color:"white")
		Window.on :key do |e| Window.close end
	end 

	def convert_to_screen(x,y)
		x = x * @width
		y = @height / 2 - y * @height * 1.823
		[x,y]
	end

	def draw_from_projection(x,y)
		p = convert_to_screen(x,y)
		Circle.new(x:p[0],y:p[1],radius:2,color:"red")
	end 

	def draw_line(air1,air2)
		a1 = convert_to_screen(air1.xProject,air1.yProject)
		a2 = convert_to_screen(air2.xProject,air2.yProject)
		Line.new(x1:a1[0],y1:a1[1],x2:a2[0],y2:a2[1],color:"black")
	end

	def display
		Window.show
	end
end

md = Map_Display.new
adb = Airport_Database.new 
adb.get_all_airports.each do |key|
	apt = adb.get_airport(key)
	md.draw_from_projection apt.xProject,apt.yProject 
end
md.draw_line adb.get_airport("LGW"),adb.get_airport("MCO")
md.display

