require 'json'

module Bamboo
  class Client
    attr_accessor :host

    def initialize(host)
      @host = host
      @uri = URI(host)

      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = @uri.is_a?(URI::HTTPS)
      @http.start # for keep-alive
    end

    def create_service(id, definition)
      post('/api/services', { 'Id' => id }.merge(definition))
    end

    def update_service(id, definition)
      put(service_path(id), { 'Id' => id }.merge(definition))
    end

    def delete_service(id)
      delete(service_path(id))
      true
    end

    def get_service(id)
      state.fetch('Services')[id]
    end

    # @returns Array<Hash>
    def apps
      state.fetch('Apps')
    end

    # @returns Array<Hash>
    def services
      state.fetch('Services').values
    end

    def state
      get('/api/state')
    end

    class InvalidResponseError < StandardError
      attr_reader :code, :body

      def initialize(response)
        @code = response.code
        @body = response.body
        super("Unexpected response: #{@code}, #{@body}")
      end
    end

    private

    def post(path, body)
      request Net::HTTP::Post.new(path), body
    end

    def delete(path)
      request Net::HTTP::Delete.new(path)
    end

    def put(path, body)
      request Net::HTTP::Put.new(path), body
    end

    def get(path)
      request Net::HTTP::Get.new(path)
    end

    def service_path(id)
      File.join('/api/services', id.to_s.gsub('/','%252F'))
    end

    def request(req, body = nil)
      req.body = case body
                   when String then body
                   else JSON.generate(body)
                 end if req.request_body_permitted?

      req.content_type = 'application/json'

      if @uri.user || @uri.password
        req.basic_auth(@uri.user, @uri.password)
      end

      handle_response @http.request(req)
    end

    def handle_response(response)
      case response
        when Net::HTTPSuccess
          parse_response(response)
        else
          raise InvalidResponseError, response
      end
    end

    def parse_response(response)
      case body = response.body
        when 'null' then nil
        when String then JSON.parse(body)
      end
    end
  end
end
