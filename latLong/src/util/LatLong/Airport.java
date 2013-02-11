package util.LatLong;

import lombok.Getter;

public class Airport {
	@Getter
	Double latitude;
	@Getter
	Double longitude;
	@Getter
	String airportCode;
	@Getter
	String sql;
	
    public Airport(String htmlSnippet){
    	latitude = setLatitude(htmlSnippet);
    	longitude = setLongitude(htmlSnippet);
    	airportCode = setAirportCode(htmlSnippet);
    	sql = generateSql(latitude, longitude, airportCode);
    }

    private String generateSql(Double latitude2, Double longitude2,
			String airportCode2) {
		return null;
	}

	private String getAirportCode(String htmlSnippet) {
		return null;
	}

	private Double getLongitude(String htmlSnippet) {
		return null;
	}

	private Double getLatitude(String htmlSnippet) {
		return null;
	}

	public Double getLatitude() {
		return latitude;
	}

	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}

	public String getAirportCode() {
		return airportCode;
	}
//	String s ="xyz: 123a-45";   
//	String patternStr="xyz:[ \\t]*([\\S ]+)";
//	Pattern p = Pattern.compile(patternStr);
//	Matcher m = p.matcher(s);
//	//System.err.println(s);
//	if(m.find()){
//	    int count = m.groupCount();
//	    System.out.println("group count is "+count);
//	    for(int i=0;i<count;i++){
//	        System.out.println(m.group(i));
//	    }
//	}
	public void setAirportCode(String airportCode) {
		
		this.airportCode = airportCode;
	}

	public String getSql() {
		return sql;
	}

	public void setSql(String sql) {
		this.sql = sql;
	}

}
