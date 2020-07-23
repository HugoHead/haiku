syl = File.open("syl.txt", "r")#copies the File syl.txt to the var syl
syl = syl.each_line.to_a#makes syl an array
rand = rand(0..syl.length)#gets random # from 0 to the length of syl
runner = 0
syl2 = Array.new
while runner < syl.length do#repeat until nothing left in syl
    syl2[runner] = syl[runner].split(" ")#makes each index of syl2 and array of [word, syl_count]
    runner = runner + 1
end

#more setup:
fline = ''
rSylFline = 5 #remaining syllables in the first line.

#build the Fline (first line) of the haiku
sylNum = 1
word = 0
while rSylFline != 0 
    syl2[rand][sylNum]
    if rSylFline >= syl2[rand][sylNum].to_i
        fline = fline + syl2[rand][0].to_s + " "
        rSylFline = rSylFline - syl2[rand][sylNum].to_i
    end
    rand = rand(0..syl.length)
end
puts fline.capitalize()

#more setup:
sline = '' 
rSylSline = 7 #remaining syllables in the first line.

#build the Sline (second line) of the haiku
sylNum = 1
word = 0
while rSylSline != 0 
    syl2[rand][sylNum]
    if rSylSline >= syl2[rand][sylNum].to_i
        sline = sline + syl2[rand][0].to_s + " "
        rSylSline = rSylSline - syl2[rand][sylNum].to_i
    end
    rand = rand(0..syl.length)
end
puts sline.capitalize()

tline = '' 
rSylTline = 5 #remaining syllables in the first line.

#build the Tline (third line) of the haiku
sylNum = 1
word = 0
while rSylTline != 0 
    syl2[rand][sylNum]
    if rSylTline >= syl2[rand][sylNum].to_i
        tline = tline + syl2[rand][0].to_s + " "
        rSylTline = rSylTline - syl2[rand][sylNum].to_i
    end
    rand = rand(0..syl.length)
end
puts tline.capitalize()