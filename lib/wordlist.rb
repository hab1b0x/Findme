module FindMe
    class Wordlist
        
        ENVIRONMENTS = %w(dev development stage s3 staging prod production test)
        PERMUTATIONS = %i(permutation_raw permutation_envs permutation_host)


        class << self 
            def generate(common_prefix, prefix_wordlist)
                [].tap do |list|
                    PERMUTATIONS.each do |permutation|
                        list << send(permutation, common_prefix, prefix_wordlist)
                    end
                end.flatten.uniq
            end

            def from_file(prefix, file)
                generate(prefix, IO.read(file).split("\n"))
            end

            def permutation_raw(common_prefix, _prefix_wordlist)
                common_prefix
            end

            def permutation_envs(common_prefix, prefix_wordlist)
                [].tap do |permutations|
                    prefix_wordlist.each do |word|
                        ENVIRONMENTS.each do |environment|
                            ['%s-%s-%s', '%s-%s.%s', '%s-%s%s', '%s.%s-%s', '%s.%s.%s'].each do |bucket_format|
                                permutations << format(bucket_format, common_prefix, word, environment)
                            end
                        end
                    end
                end
            end

            def permutation_host(common_prefix, prefix_wordlist)
                [].tap do |permutations|
                    prefix_wordlist.each do |word|
                        ['%s.%s', '%s-%s', '%s%s'].each do |bucket_format|
                            permutations << format(bucket_format, common_prefix, word)
                            permutations << format(bucket_format, word, common_prefix)
                        end
                    end
                end
            end
        end
    end
end

