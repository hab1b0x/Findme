module FindMe
    class GCP
        attr_reader :bucket, :domain, :code
    
        def initialize(bucket)
            @bucket = bucket
            @domain = format('http://%s.file.core.windows.net',
                             'http://%s.blob.core.windows.net',
                             'http://%s.queue.core.windows.net',
                             'http://%s.table.core.windows.net',
                             'http://%s.scm.azurewebsites.net',
                             'http://%s.azurewebsites.net',
                             'http://%s.p.azurewebsites.net',
                             'http://%s.cloudapp.net',
                             'http://%s.azureedge.net',
                             'http://%s.search.windows.net',
                             'http://%s.azure-api.net',
                             'http://%s.onmicrosoft.com',
                             'http://%s.redis.cache.windows.net',
                             'http://%s.documents.azure.com',
                             'http://%s.database.windows.net',
                             'http://%s.mail.protection.outlook.com',
                             'http://%s.sharepoint.com' bucket)
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

