
require 'spec_helper'
require File.dirname(__FILE__) + '/../lib/csv_processor.rb'

describe "class CsvProcessor" do

  it "should implement a constructor" do
    p = CsvProcessor.new('data/some_file.csv')
    expect(p.to_s).to eq 'file: data/some_file.csv type: unknown'
  end

  it "should process a Course file" do
    p = CsvProcessor.new('data/001.csv')
    p.process
    expect(p.type).to eq :course
  end

  it "should process a Student file" do
    p = CsvProcessor.new('data/002.csv')
    p.process
    expect(p.type).to eq :student
  end

  it "should process an Enrollment file" do
    p = CsvProcessor.new('data/003.csv')
    p.process
    expect(p.type).to eq :enrollment
  end

end
