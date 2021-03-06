class LocationSqlMaker 

   @@output_location = 'output/curl'

   attr_accessor :airport_codes

  def initialize airport_codes
    @airport_codes = airport_codes
  end

  def make_sql 
    airport_codes.map { |airport_code| 
      file_location = "#{@@output_location}/#{airport_code}.html"
      if File.exist?(file_location) then
        make_sql_from_html(airport_code)
      else
        get_html_from_airnav(airport_code)
        make_sql_from_html(airport_code)
      end
    }
  end 

  def get_html_from_airnav airport_code
    output_file = "#{@@output_location}/#{airport_code}.html"
    
    data = `curl --silent http://airnav.com/airport/#{airport_code}`
    data = data.unpack("C*").pack("U*") # prevents utf-8 character errors

    if data == "" then 
      puts "No data found; is there an internet connection?"
    else 
      puts "Got data for #{airport_code}, writing to file"
      File.open(output_file, 'w').write(data) 
    end
  end

  def make_sql_from_html airport_code
    location = "#{@@output_location}/#{airport_code}.html"
    File.exists?(location) ? get_sql_from_file(location) : []
  end

  def make_sql_locally location_of_html
    files = Dir.entries(location_of_html)
    files.map {|filename|
      if filename != "." && filename != ".." then
        matcher = (filename.match /(...)\.html/)
        if ! matcher.nil? then
          get_sql_from_file("#{location_of_html}/#{filename}")
        end
      end
    }.compact
  end

  def get_sql_from_file location
    f = File.open(location)
    airport_code = (location.match /(...)\.html/)[1]
    contents = f.read
    make_sql_from_file_contents(contents, airport_code)
  end

  def make_sql_from_file_contents contents, airport_code
    matcher = contents.match /.*latitude=(.*)&longitude=(.*)&name.*/
    if (!matcher.nil? && matcher[1] && matcher[2]) then 
      latitude = matcher[1]
      longitude = matcher[2]
      sql = ["update station set latitude=(#{latitude}), longitude=(#{longitude}) where airport_code = '#{airport_code}';"]
    end
    sql
  end
end