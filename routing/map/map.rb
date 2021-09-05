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
		[535,246]
	end
	def southAmericaLat
		413
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
		convert(0,55)

		plot(0,0,"white")
		plot(-180,0,"green")
		plot(180,0,"yellow")

		plot(-73.995,41.145,"yellow")  											# New York
		plot(144.04,-37.9,"red") 												# Melbourne
		plot(-67.29,-55.83,"red") 												# SA tip
		plot(-0.45,51.46,"red")													# LHR
		plot(157.23,50.88,"red") 												# Tip of long Siberian Island
		plot(-155.37,19.51,"red")												# Hawaii
	end 

	def plot(x,y,col)
		c = convert(x,y)
		draw c[0],c[1],col
	end 

	def draw(x,y,colour = "yellow")
		Circle.new(x:x,y:y,radius:5,color:colour)
	end

	def to_r(d)
		d * Math::PI / 180.0
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
			yos = (@image.centre[1]-@image.southAmericaLat).abs 			
			@scalar = (1.0 * yos / yo).abs
			puts yo,yos,@scalar
		end
		[x,@image.centre[1]*@scale/100-yo*@scalar*@scale/100]
	end
end

md = MapDisplay.new(ImageCreator.new)
md.display


# Size 1122 x 453 
# 0 deg Greenwich Meridian = 563 across
# 0 deg Equator (Islands just south of Singapore) 266 down
# -55 deg Southern tip of South American Continent 433 down