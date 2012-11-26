class LocationSqlMaker 

   @@output_location = 'output/curl'

   attr_accessor :airport_codes

  def initialize airport_codes
    @airport_codes = airport_codes
  end

  def make_sql 
    airport_codes.map { |airport_code| 
      if ! File.exist?("@@output_location/#{airport_code}.html") then 
        get_html_for_airport_code(airport_code)
      else
    # this is broken
      make_sql_from_html(airport_code)
    end
    }
  end 

  def get_html_for_airport_code airport_code
    output_file = "#{@@output_location}/#{airport_code}.html"
    if File.exists?(output_file) then 
      puts "file exists already, skipping query for #{airport_code}"
      return 
    end

    data = `curl --silent http://airnav.com/airport/#{airport_code}`
    data = data.unpack("C*").pack("U*")

    if data == "" then 
      puts "No data found; is there an internet connection?"
    else 
      File.open(output_file, 'w').write(data) 
    end
  end

  def make_sql_from_html airport_code
    location = "#{@@output_location}/#{airport_code}.html"
    if File.exists?(location) then
      f = File.open(location)
      contents = f.read
      matcher = contents.match /.*latitude=(.*)&longitude=(.*)&name.*/
      if (!matcher.nil? && matcher[1] && matcher[2]) then 
        latitude = matcher[1]
        longitude = matcher[2]
        "update station set latitude=(#{latitude}), longitude=(#{longitude}) where airport_code = '#{airport_code}';"
      end
    end
  end
end