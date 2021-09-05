#
# 		Represents one airport
#
class Airport
	def initialize(line)
		@data = line.strip().split(":")
	end
	def icao 
		@data[0].upcase
	end
	def iata
		@data[1].upcase
	end
	def name
		capitalize_all @data[2] == "N/A" ? city : @data[2]
	end
	def city
		capitalize_all @data[3]
	end
	def country
		capitalize_all @data[4]
	end
	def latitude
		@data [14].to_f
	end
	def longtitude
		@data [15].to_f
	end

	def capitalize_all(str)
		str.gsub("-"," ").split(" ").collect { |a| a.downcase.capitalize }.join " "
	end

end
#
# 		Represents the main database.
#
class AirportDatabase
	def initialize
		iataList = open("iata.list").read.split
		@all_airports = {}
		open("GlobalAirportDatabase/GlobalAirportDatabase.txt").readlines.each do |l| 
			air = Airport.new l
			@all_airports[air.iata] = air if iataList.include? air.iata
		end		
	end

	def get_all_airports
		@all_airports.keys.sort_by {|k| @all_airports[k].icao }
	end

	def get_airport(iata)
		@all_airports[iata.upcase]
	end

	def create(target)
		h = open(target,"w")
		get_all_airports.each { |a| render_one(h,@all_airports[a]) }
		h.close
	end

	def render_one(h,air)
		elements = [air.icao,air.name,air.city,air.country,air.latitude.to_s,air.longtitude.to_s]
		h.syswrite (elements.collect { |a| '"'+a+'"'}.join ",")+"\n"
	end
end

if __FILE__ == $0 
	db = AirportDatabase.new
	db.create("test.txt")
	air = db.get_airport("LGW")
	puts "#{air.icao} #{air.iata} #{air.name} #{air.city} #{air.country} #{air.latitude} #{air.longtitude}"
	puts db.get_all_airports.join(" ")
end
