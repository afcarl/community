
Given(/^the standard fixture data is loaded$/) do
  SeedData.new({:verbose => true}).load
end
