package test.util.LatLong;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

import util.LatLong.Airport;

public class AirportTest {
	Airport airport;
	@Before
	public void setUp(){
		airport = new Airport("&latitude=1&longitude=2&name=FOOW");
	}
    
    @Test
    public void shouldContainSqlWhenGivenAirportCode(){
        String expectedSql = "update station set latitude=(1), longitude=(1) where airport_code = 'FOO';";
        assertEquals(expectedSql, airport.getSql());
    }
    
    @Test
    public void creatingAirportShouldPopulateBasicFields(){
    	assertTrue(1 == airport.getLatitude());
    	assertTrue(2 == airport.getLongitude());
    }
}
