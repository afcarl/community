
module Debugging

  def log_page(test_context=nil)
    if page
      sio = StringIO.new
      sio << "begin_log_page \n"
      sio << "page test context: #{test_context} \n" if test_context
      sio << "page status_code:  #{page.status_code} \n"
      sio << "page current_host: #{page.current_host} \n"
      sio << "page current_path: #{page.current_path} \n"
      sio << "page current_url:  #{page.current_url} \n"
      sio << "page body:\n #{page.body} \n"
      sio << "page text:\n #{page.text} \n"
      sio << "end_log_page \n"
      Rails.logger.debug(sio.string)
    end
  end

end
