module FindMe
    class Scanner
        def initialize(scan)
            @target = FindMe::S3.new scan
        end

        def scan
            @target  && @target.exists?
                bucket = FindMe::S3.new @target.bucket
                if bucket.exists?
                    puts "Found bucket: #{bucket.bucket} (#{bucket.code})".red
                else
                    puts "Bucket not found: #{bucket.bucket} (#{bucket.code})".red
                end
            end
        end
    end
