require "test_helper"

# rake test:file file=test/helpers/application_helper_test.rb

class ApplicationHelperTest < ActionView::TestCase

  test "method 'app_name'" do
    app_name.must_equal('DAPI')
  end

  test "method 'bootstrap_flash_class'" do
    bootstrap_flash_class(:notice).must_equal('bg-success')
    bootstrap_flash_class(:error).must_equal('bg-danger')
    bootstrap_flash_class(:alert).must_equal('bg-info')
    bootstrap_flash_class(nil).must_equal('none')
    bootstrap_flash_class(:unexpected).must_equal('none')
  end

end
