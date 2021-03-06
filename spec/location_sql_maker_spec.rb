require_relative "../lib/location_sql_maker.rb"

describe LocationSqlMaker do

  output_location = 'output/curl'
  test_airport_code = 'FOO'
  f = "#{output_location}/#{test_airport_code}.html"

  before do
    if  File.exists?(f) then File.delete(f) end
  end

  after do
    if  File.exists?(f) then File.delete(f) end
  end

  describe "make_sql_from_file_contents" do
    it "should make sql from file contents" do
      subject = LocationSqlMaker.new([test_airport_code])
      contents = '<A href="http://www.mapquest.com/maps/map.adp?latlongtype=decimal&zoom=6&latitude=1&longitude=1&name=FOOW" target="airport_maps">MapQuest</A>'
      sql = subject.make_sql_from_file_contents(contents, test_airport_code)
      sql.should == ["update station set latitude=(1), longitude=(1) where airport_code = 'FOO';"]
    end
  end

  describe "#thing" do
    subject = LocationSqlMaker.new(['BAF'])

    it "should make sql out of file" do
      expected_sql = "update station set latitude=(42.157944), longitude=(-72.715861) where airport_code = 'BAF';"
      subject.make_sql_from_html('BAF').should == [expected_sql]
    end

    it "should get html file from website" do
      File.exists?(f).should == false
      subject.get_html_from_airnav(test_airport_code)
      File.exists?(f).should == true
    end
  end

  describe "#make_sql_from_html" do
    subject = LocationSqlMaker.new(['BAF'])

    it "should make sql out of file" do
      expected_sql = "update station set latitude=(42.157944), longitude=(-72.715861) where airport_code = 'BAF';"
      subject.make_sql_from_html('BAF').should == [expected_sql]
    end
  end

  describe "#make_sql_locally" do
    subject = LocationSqlMaker.new(['BAF'])

    it "makes sql from any local files" do
      made_sql = subject.make_sql_locally("spec/spec_output/")
      made_sql.count.should == 1
      expected_sql = "update station set latitude=(1), longitude=(1) where airport_code = 'FOO';"
      made_sql.first.should == [expected_sql]
    end
  end
end
