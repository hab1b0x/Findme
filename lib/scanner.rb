module FindMe
    class Scanner
        def initialize(scan)
            @aws = FindMe::S3.new(scan) 
            @gcp = FindMe::GCP.new(scan) 
            @azure =  FindMe::AZURE.new(scan)
        end

        def scan_s3
            @aws  && @aws.exists?
                bucket = FindMe::S3.new @aws.bucket
                if bucket.exists?
                    puts "S3 Found bucket: #{bucket.bucket} (#{bucket.code})".red
                else
                    puts "Bucket not found: #{bucket.bucket} (#{bucket.code})".red
                end
        end

        def scan_gcp
            @gcp  && @gcp.exists?
                bucket = FindMe::GCP.new @gcp.bucket
                if bucket.exists?
                    puts "GCP Found bucket: #{bucket.bucket} (#{bucket.code})".red
                else
                    puts "Bucket not found: #{bucket.bucket} (#{bucket.code})".red
                end
        end

        def scan_azure
            @azure  && @azure.exists?
                bucket = FindMe::AZURE.new @azure.bucket
                if bucket.exists?
                    puts "Azure Found bucket: #{bucket.bucket} (#{bucket.code})".red
                else
                    puts "Bucket not found: #{bucket.bucket} (#{bucket.code})".red
                end
        end
    end
end
