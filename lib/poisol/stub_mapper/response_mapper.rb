module Poisol 
  module ResponseMapper
    extend self

    def map webrick_request
      stub_request = get_stub_request webrick_request
      PoisolLog.info stub_request.to_s
      get_stub_response stub_request
    end

    def get_stub_request webrick_request
      stub_request = Request.new 
      stub_request.type = webrick_request.request_method.downcase
      stub_request.url = webrick_request.request_uri.path
      stub_request.query = webrick_request.query_string
      stub_request.body = webrick_request.body
      stub_request
    end


    def get_stub_response stub_request
      stub = Stubs.get_match stub_request
      if stub.blank?
        log_error stub_request
        raise "No match found for request: #{stub_request.to_s} "
      end
      PoisolLog.info JSON.pretty_generate(stub.response.body)
      stub.response if stub.present?
    end

    def log_error request
      Kernel.puts request.to_s
      Kernel.puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^No match found for above request"
      Kernel.puts "Registered requests are: #{Stubs.all.map{|stub| "\n#{stub.request.to_s}"}.join}\n--end--"
      PoisolLog.error "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^No match found for above request"
      PoisolLog.error "Registered requests are: #{Stubs.all.map{|stub| "\n#{stub.request.to_s}"}.join}\n--end--"
    end

  end
end
