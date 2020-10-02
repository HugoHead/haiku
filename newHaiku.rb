class Data
    attr_accessor :arrays, :col0, :col1, :col2, :col3 
    def computeCols
        self.col0 = data.map {|row| row[0]}.to_a
        self.col1 = data.map {|row| row[1]}.to_a
        self.col2 = data.map {|row| row[2]}.to_a
        self.col3 = data.map {|row| row[3]}.to_a
    end
    def initialize
        syl = File.open("finalData.txt", "r")#copies the File syl.txt to the var syl
        syl = syl.each_line.to_a#makes syl an array
        runner = 0
        syl2 = Array.new
        while runner < syl.length do#repeat until nothing left in syl
            syl2[runner] = syl[runner].split("\t")#makes each index of syl2 and array of [word, syl_count]
            runner = runner + 1
        end

        self.arrays = syl2

        computeCols
    end
end

def findSylCount word, data
    col1 = data.map {|row| row[0]}.to_a
    col2 = data.map {|row| row[3]}.to_a
    table = Hash[col1.zip(col2)]

    return table[word].to_i
end

def wordPlacement line, data, sylLeft
    if line == ""
        return false
    end

    lineArr = line.split(" ")

    col1 = data.map {|row| row[0]}.to_a
    col2 = data.map {|row| row[1]}.to_a
    table = Hash[col1.zip(col2)]

    totalSyl = 0

    if sylLeft <= 0 && table[lineArr.last] == "Det"
        return false
    end

    lineArr.length.times do |n|
        if n != 0
            if table[lineArr[n - 1]] == "Det"
                if table[lineArr[n]] != "NoC" and table[lineArr[n]] != "Adj"and table[lineArr[n]] != "Adv"
                    return false
                end
            elsif table[lineArr[n - 1]] == "Adj"
                if table[lineArr[n]] != "NoC" and table[lineArr[n]] != "Pron" and table[lineArr[n]] != "NoP"
                    return false
                end
            end
        end
    end   
    return true
end

def drawWord data
    totalFeq = 0
    data.length.times do |n|
        totalFeq += data[n].split("\t")[2].to_i
    end
    

    col1 = data.map {|row| row.split("\t")[0]}.to_a
    col2 = data.map {|row| row.split("\t")[2]}.to_a

    table = Hash[col1.zip(col2)]

    raffle = []

    #puts table

    table.map do |word, freq|
        freq.to_i.times { raffle << word }
    end

    value = raffle.sample
    value = data[col1.index(value)]
    return value

    puts "err: drawWord escaped"
end

def makeLine syls, syl2, syl
    #more setup:
    fline = ''
    rSylFline = syls #remaining syllables in the first line.

    #build the Fline (first line) of the haiku
    sylNum = 3
    word = 0
    fline = ""
    selectedWord = ""

    grammer = false
    while rSylFline != 0 || grammer
        if grammer && fline != "" && rSylFline != 5
            lastWord = fline.split(' ').last
            fline = fline.split(' ')[0...-1].join(' ') + " "
            rSylFline += findSylCount(lastWord, syl2)
        end

        selectedWord = drawWord (syl)
        selectedWord = selectedWord.split("\t")
        if rSylFline >= selectedWord[sylNum].to_i
            fline = fline + selectedWord[word].to_s + " "
            rSylFline = rSylFline - selectedWord[sylNum].to_i
        end

        grammer = !wordPlacement(fline, syl2, rSylFline)
    end
    return fline
end


syl = File.open("finalData.txt", "r")#copies the File syl.txt to the var syl
syl = syl.each_line.to_a#makes syl an array
rand = rand(0..syl.length)#gets random # from 0 to the length of syl
runner = 0
syl2 = Array.new
while runner < syl.length do#repeat until nothing left in syl
    syl2[runner] = syl[runner].split("\t")#makes each index of syl2 and array of [word, syl_count]
    runner = runner + 1
end

#$data = Data.new 



=begin
#more setup:
sline = '' 
rSylSline = 7 #remaining syllables in the first line.

#build the Sline (second line) of the haiku
word = 0
while rSylSline != 0 
    syl2[rand][sylNum]
    if rSylSline >= syl2[rand][sylNum].to_i
        sline = sline + syl2[rand][0].to_s + " "
        rSylSline = rSylSline - syl2[rand][sylNum].to_i
    end
    rand = rand(0..syl.length)
end


tline = '' 
rSylTline = 5 #remaining syllables in the first line.

#build the Tline (third line) of the haiku
word = 0
while rSylTline != 0 
    syl2[rand][sylNum]
    if rSylTline >= syl2[rand][sylNum].to_i
        tline = tline + syl2[rand][0].to_s + " "
        rSylTline = rSylTline - syl2[rand][sylNum].to_i
    end
    rand = rand(0..syl.length)
end

=end

fline = makeLine 5, syl2, syl
sline = makeLine 7, syl2, syl
tline = makeLine 5, syl2, syl

puts fline.capitalize()
puts sline.capitalize()
puts tline.capitalize()