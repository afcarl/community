Given(/^the user visits path '(.*)'$/) do | path_to_visit |
  visit path_to_visit
end

Given(/^the page status code is '(.*)'$/) do | status_code |
  assert page.status_code == status_code.to_i
end

Given(/^the page has content: (.*)$/) do | content |
  assert(page.html.include?(content), "content not found: #{content}")
end

Given(/^the user clicks the link '(.*)'$/) do | link_text |
  click_link(link_text)
end

Given(/^the page path is '(.*)'$/) do | path |
  assert(page.current_path == path, "page path is #{page.current_path}; should be #{path}")
end

Given(/^the page is logged$/) do
  log_page
end
