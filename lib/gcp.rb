module FindMe
    class GCP
        attr_reader :bucket, :domain, :code
    
        def initialize(bucket)
            @bucket = bucket
            @domain = format('http://%s.storage.googleapi.com', 'http://%s.appspot.com' bucket)
        end

        def exists?
            code != 404
        end

        def code
            http && http.code.to_i
        end

        private

        def http
            Timeout::timeout(5) do
                @http ||= Net::HTTP.get_response(URI.parse(@domain))
            end
        rescue
        end
    end
end

