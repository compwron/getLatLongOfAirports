class LocationSqlMaker 

   @@output_location = 'output/curl'

   attr_accessor :airport_codes

  def initialize airport_codes
    @airport_codes = airport_codes
  end

  def make_sql 
    results = []
    airport_codes.map { |airport_code| 
      file_location = "#{@@output_location}/#{airport_code}.html"
      if File.exist?(file_location) then
        make_sql_from_html(airport_code)
      else
        get_html_for_airport_code(airport_code)
      end
    }
  end 

  def get_html_for_airport_code airport_code
    output_file = "#{@@output_location}/#{airport_code}.html"
    
    if File.exists?(output_file) then
      make_sql_from_html(airport_code)
      return
    end

    data = `curl --silent http://airnav.com/airport/#{airport_code}`
    data = data.unpack("C*").pack("U*") # prevents utf-8 character errors

    if data == "" then 
      puts "No data found; is there an internet connection?"
    else 
      File.open(output_file, 'w').write(data) 
    end
    make_sql_from_html(airport_code)
  end

  def make_sql_from_html airport_code
    sql = []
    location = "#{@@output_location}/#{airport_code}.html"
    if File.exists?(location) then
      f = File.open(location)
      contents = f.read
      matcher = contents.match /.*latitude=(.*)&longitude=(.*)&name.*/
      if (!matcher.nil? && matcher[1] && matcher[2]) then 
        latitude = matcher[1]
        longitude = matcher[2]
        sql += ["update station set latitude=(#{latitude}), longitude=(#{longitude}) where airport_code = '#{airport_code}';"]
      end
    end
    sql
  end
end