#the purpose of this program is to compare the sylable database with the part of speach database
#this is so that they contain the same data

syl = File.open("syl.txt", "r")#copies the File syl.txt to the var syl
syl = syl.each_line.to_a
runner = 0
syl1 = Array.new
syl2 = Array.new
while runner < syl.length do#repeat until nothing left in syl
	syl1[runner] = syl[runner].split(" ")[0]
    syl2[runner] = syl[runner].split(" ")#makes each index of syl2 and array of [word, syl_count]
    runner = runner + 1
end

prt = File.open("PartOfSpeachAndFrequencyData.txt", "r")#copy the general data into prt

prt = prt.each_line.to_a
runner = 0
prt1 = Array.new
prt2 = Array.new
prt3 = Array.new
prt4 = Array.new
prt5 = Array.new
while runner < prt.length do#repeat until nothing left in syl
	prt1[runner] = prt[runner].split("\t")[0]
    prt2[runner] = prt[runner].split("\t")[1]#makes each index of syl2 and array of [word, syl_count]
    prt3[runner] = prt[runner].split("\t")[2]
    prt4[runner] = prt[runner].split("\t")[3]
    prt5[runner] = prt[runner].split("\t")[4]
    runner = runner + 1
end

#puts prt1
jflsdkjflsd = prt1 - syl1
puts jflsdkjflsd
puts jflsdkjflsd.length

#f = File.new('in the the part of speach database but not sylable  database.txt', 'w')
#f.write(jflsdkjflsd)
#f.close     