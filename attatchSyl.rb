require 'matrix'

puts "fjlsdkjf".class.class

puts "attaching syl"

f = File.open('prt4.txt', 'r')
prt = f.each_line.to_a

f = File.open('syl2.txt', 'r')
syl = f.each_line.to_a

syl.length.times do |m|
	syl[m] = syl[m].split(" ")
end

sylColOne = syl.map{|a| a[0]}

sylIndex = 0

problems = []

nPrt = []

prt.length.times do |n|
	if n < 3326
		puts n
		if prt[n].class == "NilClass"
			puts "nillllll" 
		end
		#puts prt[n]
		sylIndex = sylColOne.index(prt[n].split("\t")[0])
		if sylIndex != nil
			nPrt.push(prt[n] + ("\t" + syl[sylIndex][1] + "\n"))
		else
			if prt[n].split("\t")[0] == "Num"
				puts prt [n]
			else
				problems.push(prt[n])
				prt.delete_at(n)
			end
		end
	end
end

f = File.new('finalData.txt', 'w')
nPrt.each do |j|
    f.write(j)
end
f.close

puts problems.length