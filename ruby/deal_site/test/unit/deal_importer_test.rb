require 'test_helper'

class DealImporterTest < ActiveSupport::TestCase

  test "it should fail if not given a publisher id" do
    di = DealImporter.new({:silent => true})
    di.process_deals(false)
    assert di.fatal_error == 'publisher_id does not exist: 0', "Incorrect fatal_error message"
  end

  test "it should fail if given an invalid publisher id" do
    di = DealImporter.new({:silent => true, :publisher_id => 999999})
    di.process_deals(false)
    assert di.fatal_error == 'publisher_id does not exist: 999999', "Incorrect fatal_error message"
  end

  test "it should fail if not given a csv data file" do
    p  = FactoryGirl.create(:publisher)
    di = DealImporter.new({:silent => true, :publisher_id => p.id})
    di.process_deals(false)
    assert di.fatal_error == 'csv_data_filename does not exist: ', "Incorrect fatal_error message"
    assert di.valid_row_count == 0, 'zero csv rows should have been processed'
  end

  test "it should fail if given a non-existant csv data file" do
    p  = FactoryGirl.create(:publisher)
    di = DealImporter.new(
      {:silent => true, :publisher_id => p.id, :csv_data_filename => 'script/data/non_existant.csv' })
    di.process_deals(false)
    assert di.fatal_error == 'csv_data_filename does not exist: script/data/non_existant.csv', "Incorrect fatal_error message"
    assert di.valid_row_count == 0, 'zero csv rows should have been processed'
  end

  test "it should fail if given a non-existant csv format file" do
    p  = FactoryGirl.create(:publisher)
    di = DealImporter.new(
      {:silent => true, :publisher_id => p.id, :csv_format_filename => 'config/non_existant.json'})
    di.process_deals(false)
    assert di.fatal_error == 'csv_format_filename does not exist: config/non_existant.json', "Incorrect fatal_error message"
    assert di.valid_row_count == 0, 'zero csv rows should have been processed'
  end

  test "it should process the default csv format file" do
    p  = FactoryGirl.create(:publisher)
    di = DealImporter.new(
      {:silent => true, :publisher_id => p.id, :csv_data_filename => 'script/data/daily_planet_export.csv' })
    field_array = di.csv_file_fields
    assert field_array.class.name == 'Array', 'The csv_file_fields must be an Array'
    assert field_array[0]['index']  == 0
    assert field_array[0]['name']   == 'merchant'
    assert field_array[-1]['index'] == 5
    assert field_array[-1]['name']  == 'value'
  end

  test "it should process an alternative csv format file" do
    p  = FactoryGirl.create(:publisher)
    di = DealImporter.new(
      {:silent => true, :publisher_id => p.id,
       :csv_format_filename => 'config/alt_csv_file_format.json',
       :csv_data_filename   => 'script/data/daily_planet_export.csv' })
    field_array = di.csv_file_fields
    assert field_array.class.name == 'Array', 'The csv_file_fields must be an Array'
    assert field_array[0]['index']  == 5
    assert field_array[0]['name']   == 'merchant'
    assert field_array[-1]['index'] == 0
    assert field_array[-1]['name']  == 'value'
  end

  test "it should successfully scan a csv file" do
    p  = FactoryGirl.create(:publisher)
    di = DealImporter.new(
      {:silent => true, :publisher_id => p.id, :csv_data_filename => 'script/data/daily_planet_export.csv' })
    di.process_deals(false)
    di.eoj_report
    assert di.fatal_error.nil?, "fatal_error should be nil"
    assert di.valid_row_count == 2, '2 valid rows should have been processed'
    assert di.invalid_row_count == 1, '1 invalid row should have been processed'
    assert di.advertisers_created == 0, '0 advertisers should have been created'
    assert di.deals_created == 0, '0 deals should have been created'
  end

  test "it should successfully import a csv file" do
    p  = FactoryGirl.create(:publisher)
    di = DealImporter.new(
      {:silent => true, :publisher_id => p.id, :csv_data_filename => 'script/data/daily_planet_export.csv' })
    di.process_deals(true)
    di.eoj_report
    assert di.fatal_error.nil?, "fatal_error should be nil"
    assert di.valid_row_count == 2, '2 valid rows should have been processed'
    assert di.invalid_row_count == 1, '1 invalid row should have been processed'
    assert di.advertisers_created == 2, '2 advertisers should have been created'
    assert di.deals_created == 2, '2 deals should have been created'

    a = Advertiser.find_by_name('Arbys')
    assert a.nil? == false, 'The Advertiser Arbys was not created'
    assert a.publisher_id == p.id,  'The Advertiser Arbys was created with an incorrect publisher_id'

    d = Deal.find_by_description('More burgers')
    assert d.nil? == false, 'The Deal More burgers was not created'
    assert d.advertiser_id == a.id,  'The Deal More burgers was created with an incorrect advertiser_id'
  end

end
