require_relative "../lib/location_sql_maker.rb"

describe LocationSqlMaker do

  describe "#thing" do
    subject = LocationSqlMaker.new(['BAF'])

    it "should make sql out of file" do
      
      expected_sql = "update station set latitude=(42.157944), longitude=(-72.715861) where airport_code = 'BAF';"
      subject.make_sql_from_html('BAF').should == expected_sql
    end

    it "should get html file from website" do
      subject.get_fi
    end
  end
end
