def getwidths(length,height)
	widths = Array.new(height, 0)
	length.times do |i|
		widths[i] = 1
	end
	length.times do |i|
		widths[length + i] = length - i
	end
	widths
end

def new_frontier(frontier, widths, height)
	max_sum = 0
	max_row = 0
	height.times do |r|
		next if widths[r] == 0
		sum = widths[r] + frontier[r]
		if sum > max_sum
			max_sum = sum
			max_row = r
		end
	end
	intersect = max_sum
	newfront = frontier.dup
	height.times do |r| 
		next if widths[r] == 0
		newfront[r] = intersect + widths[r] - 1
	end
	return newfront, intersect
end

def tree_grid (words, bases,maxlen, height)
	grid = Array.new(height) { Array.new(maxlen, ' ') }
	trees = words.zip(bases)
	trees.each do |t|
		word, base = *t
		revw = word.reverse
		word.length.times do |i|
			grid[i][base] = revw[i]
		end
		word.length.times do |i|
			(word.length-i).times do |j|
				grid[i+word.length][base + j] = revw[j+i]
				grid[i+word.length][base - j] = revw[j+i]
			end
		end
	end
	return grid.reverse
end

def print_row(sentence)
	words = sentence.split
	height = words.map { |e| e.length * 2 }.max
	frontier = Array.new(height, 0)
	bases = []
	words.each do |w|
		widths = getwidths(w.length,height)
		frontier, base = new_frontier(frontier, widths, height)
		bases << base
	end
	maxlen = frontier.max
	grid = tree_grid(words, bases.map {|b| b - 1},maxlen,height)
	grid.map! { |r| r.join }
	output = "\n"
	grid.each { |r| 
		output << r << "\n"
	}
	output << "=" * maxlen
	output
end
loop do
	print "Input: "
  	line = gets
 	break if !line or line =~ /^[qQ]|^exit/
	puts print_row(line)
end