
def assert_patterns_equal(actual_tokens, expected_tokens)
  if actual_tokens.size != expected_tokens.size
    fail(fail_msg)
  else
    expected_tokens.each_with_index do | etok, idx |
      atok = actual_tokens[idx]
      if etok == '{*}'    # match anything that isn't empty
        atok.size.should > 0
      elsif etok == '{n}' # match integers
        atok.should == atok.to_i.to_s
      else
        atok.should == etok
      end
    end
  end
end

Given(/^the page path is '(.*)'$/) do | path |
  page.current_path.should == path
end

Given(/^the page path matches pattern '(.*)'$/) do | expected_path_pattern |
  actual_path = page.current_path
  actual_path_tokens = actual_path.split('/')
  expected_path_tokens = expected_path_pattern.split('/')
  assert_patterns_equal(actual_path_tokens, expected_path_tokens)
end

Given(/^the page has the text '(.*)'$/) do | text |
  page.body.include?(text).should be_true
end

Given(/^the following text, in this sequence, is expected in the page body:$/) do | table |
  expected_contents_array = []
  table.raw.each { | row | expected_contents_array << row[0].strip }

  page_body, found_index = page.body, -1
  expected_contents_array.each do | sought_text |
    found_index = page_body.index(sought_text, found_index + 1)
    if found_index.nil?
      flunk("text not found in sequence: #{sought_text}")
    end
  end
end

Given(/^the '(.*)' button is (.*)$/) do | link_text, present_absent |
  link_bool, button_bool = has_link?(link_text), has_button?(link_text)
  if present_absent.downcase == 'present'
    unless link_bool || button_bool
      fail("button not found")
    end
  elsif present_absent.downcase == 'absent'
    if link_bool || button_bool
      fail("button found")
    end
  else
    pending "this test case is pending"
  end
end
