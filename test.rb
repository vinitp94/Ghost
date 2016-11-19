dictionary = File.readlines('dictionary.txt').map(&:chomp)
temp_frag = 'cu'
p dictionary.any? { |word| word =~ /^#{temp_frag}/ }
