
Given(/^the user visits the application root path$/) do
  visit '/'
end

Given(/^the user visits path '(.*)'$/) do | path_to_visit |
  visit path_to_visit
end

Given(/^the user clicks the link '(.*)'$/) do | link_text |
  first(:link, link_text).click
end

Given(/^the user clicks the '(.*)' button$/) do | button_text |
  click_button(button_text)
end

Given(/^the user fills in field '(.*?)' with '(.*?)'$/) do | field_name, field_value |
  fill_in field_name, :with => field_value
end

Given(/^the user selects option '(.*?)' from '(.*?)'$/) do | option_value, select_field |
  select option_value, :from => select_field
end

Given(/^the user clicks the Edit link$/) do
  find_by_id('edit-glyph-link').click
end
