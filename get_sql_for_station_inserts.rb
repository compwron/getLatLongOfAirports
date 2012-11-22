airport_codes = File.open("all_stations.txt").to_a.map { |station| station.gsub!("\n", "")}.reverse

airport_codes.map { |airport_code|
	generated_sql = nil
	`sleep 1`
	html = `curl --silent http://airnav.com/airport/#{airport_code}`
	matcher = html.match /.*latitude=(.*)&longitude=(.*)&name.*/
	if (!matcher.nil? && matcher[1] && matcher[2]) then 
		latitude = matcher[1]
		longitude = matcher[2]
		puts "update station set latitude=(#{latitude}), longitude=(#{longitude}) where airport_code = '#{airport_code}';"
	end
}
