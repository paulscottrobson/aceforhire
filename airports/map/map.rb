require "ruby2d"

class ImageCreator
	def initialize
		@image = Image.new("map.png")
	end
	def resize(w,h)
		@image.width = w 
		@image.height = h 
	end
	def size
		[@image.width,@image.height]
	end
	def centre
		[1005,494]
	end
	def southAmericaLat
		810
	end
end

class GfxImageCreator <ImageCreator
	def initialize
		@image = Image.new("map2.jpg")
	end
	def centre
		[@image.width/2,@image.height/2]
	end
	def southAmericaLat
		875
	end
end


class MapDisplay 
	def initialize(image,scale = 100) 
		@image = image
		@width = image.size[0] * scale / 100
		@height = image.size[1] * scale / 100
		@scale = scale
		Window.set width:@width,height:@height
		Window.set background:"green",title:"Route map"
		image.resize @width,@height
		ctr = image.centre
		Line.new(x1:ctr[0]*scale/100,x2:ctr[0]*scale/100,y1:0,y2:image.size[1]*scale/100,color:"white")
		Line.new(x1:0,x2:image.size[0]*scale/100,y1:ctr[1]*scale/100,y2:ctr[1]*scale/100,color:"white")
		Window.on :key do |e| Window.close end

		@scalar = 0 															# no scalar, yet.
		convert(0,55.5)

		plot(0,0,"white")
		plot(-180,0,"green")
		plot(180,0,"yellow")

		plot(-73.995,41.145,"red")  											# New York
		plot(144.04,-37.9,"red") 												# Melbourne
		plot(-67.29,-55.5,"red") 												# SA tip
		plot(-0.45,51.46,"yellow")												# LHR
		plot(157.23,50.88,"red") 												# Tip of long Siberian Island
		plot(-155.37,19.51,"red")												# Hawaii
		plot(19.887,-34.969,"red")
		plot(-19.887,-34.969,"red")
	end 

	def plot(x,y,col)
		c = convert(x,y)
		draw c[0],c[1],col
	end 

	def draw(x,y,colour = "yellow")
		Circle.new(x:x,y:y,radius:3,color:colour)
	end

	def to_r(d)
		Math::PI / 180.0 * d
	end

	def display
		Window.show
	end

	def convert(long,lat)
		r = 1.0 * @width / (2 * Math::PI) 											# radius calculation
		#
		# 		Calculate X position / Longtitude
		#
		x = r * to_r(long+180.0) 
		#
		# 		Calculate Y position / Latitude
		#
		yo = r * Math.log(Math.tan(Math::PI / 4.0 + to_r(lat) / 2.0),Math::E)
		if @scalar == 0 
			yos = @image.centre[1]-@image.southAmericaLat			
			@scalar = (1.0 * yos / yo).abs
			puts @scalar
		end
		[x,@image.centre[1]*@scale/100-yo*@scalar*@scale/100]
	end
end

md = MapDisplay.new(GfxImageCreator.new)
md.display

