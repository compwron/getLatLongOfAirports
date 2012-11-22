class LocationSqlMaker 

def initialize stations
  @airport_codes = airport_codes
end

def make_sql 
airport_codes.map { |airport_code| 
  if File.exist?("#{airport_code.html}") then 
    make_sql_from_html(airport_code)
  else
    get_html_for_airport_code(airport_code)
  end
}

def get_html_for_airport_code airport_code
  `curl --silent http://airnav.com/airport/#{airport_code}` > "#{airport_code}.html"
end

def make_sql_from_html airport_code
  f = File.open("#{airport_code}.html")
  contents = f.read(f)
  matcher = contents.match /.*latitude=(.*)&longitude=(.*)&name.*/
  if (!matcher.nil? && matcher[1] && matcher[2]) then 
    latitude = matcher[1]
    longitude = matcher[2]
  end
  `echo "update station set latitude=(#{latitude}), longitude=(#{longitude}) where airport_code = '#{airport_code}';" >> sql.txt`
end
end