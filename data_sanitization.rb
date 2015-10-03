#/usr/bin/env ruby

while STDIN.gets
	input = $_
	cols = input.split ","
	loudness = cols[1]
	c = loudness[0]
	if c == "0"
		puts input
	end
end