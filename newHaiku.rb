require 'gingerice'
require './lib/VowlCheck.rb'

beginning = Time.now


$grammerCheck = (ARGV[0] == "--raw")

def findSylCount word
    return $sylsLookupTable[word].to_i
end

def wordPlacement line, data, sylLeft
    #check to see if words are plaeced properly
    if line == ""
        return false
    end

    lineArr = line.split(" ")

    table = Hash[$col[0].zip($col[1])]

    totalSyl = 0

    #check to see if the lsat word is a determiner
    #this way, the program does not hang as there are no sylalles left,
    #but it is not grammatical either because the determiner does not have a noun
    if sylLeft <= 0 && table[lineArr.last] == "Det"
        return false
    end

    lineArr.length.times do |n|
        thisWord = $col[0][n]
        prevWord = $col[0][n - 1]

        thisWordPrt = table[lineArr[n]]
        prevWordPrt = table[lineArr[n - 1]]

        ################################################################################
        #ensure that there are not two of the same word right next to one another.
        #ideally, this would never happen if all the proper grammer rules are followed.
        #however, this will save a little computation and act as a safty net
        #the exeption is of cource adjectives and adverbs 
        #e.g. "stupid stupid old man", "very very big ball"
        if (thisWord == prevWord) && (thisWordPrt != "Adj" || thisWordPrt != "Adv")
            return false
        end
        ##############################################################################

        if n != 0
            if prevWordPrt == "Det"
                if thisWordPrt != "NoC" and thisWordPrt != "Adj"and thisWordPrt != "Adv"
                    return false
                end
            elsif prevWordPrt == "Adj"
                if thisWordPrt != "NoC" and thisWordPrt != "Pron" and thisWordPrt != "NoP"
                    return false
                end
            end
        end
    end

    return true
end

def minorCorrection line
    vowelCheck = VowelCheck.new

    if line == ""
        return line
    end

    lineArr = line.split(" ")

    if lineArr.length == 1 or lineArr.length == 0
        return line
    end

    if lineArr.include? ("a")
        if lineArr.index("a") == lineArr.length + 1
            return line
        elsif lineArr.index("a") == lineArr.length
            if vowelCheck.startsWithAVowel(lineArr.last)
                lineArr[lineArr.index("a")] = "an"
                return lineArr.join(" ")
            end
        end
    end
    if lineArr.include? ("an")
        if lineArr.index("an") == lineArr.length + 1
            return line
        elsif lineArr.index("an") == lineArr.length
            if vowelCheck.startsWithAVowel(lineArr.last)
                lineArr[lineArr.index("an")] = "a"
                return lineArr.join(" ")
            end
        end
    end

    return line
end
def drawWord
    #randomly pick a word. Weighted on frequency.
    value = $listOfWordsWeightedOnFrequency.sample#Note that this function will return an int
    return value
end

def makeLine syls, syl2, syl
    #more setup:
    line = ''
    rSylLine = syls #remaining syllables in the first line.

    #build the Fline (first line) of the haiku
    sylNum = 3
    word = 0
    line = ""
    selectedWord = ""

    grammer = false
    while rSylLine != 0 || grammer
        #if either the line is incomplete of ingrammatical, 
        #we need to keep working on it

        #below is a check if the line is not gramatical
        #all other checks prevents edgecases
        if grammer && line != "" && rSylLine != syls
            #find the last word in line
            lastWord = line.split(' ').last
            #remove it
            line = line.split(' ')[0...-1].join(' ') + " "
            #add its sylablle counts back into the remaining sylablles
            rSylLine += findSylCount lastWord
        end

        #pick a word randomly.
        selectedWord = drawWord.to_s
        #find the sylablle count
        sylsInSelectedWord = findSylCount selectedWord

        #check to see if the word is too large to fit the line
        if rSylLine >= sylsInSelectedWord
            #If not, add the word to the end of the line.
            line = line + selectedWord + " "
            #reduce the number of sylablles remaining in the line accordingly
            rSylLine = rSylLine - sylsInSelectedWord
        end

        #determine wheather or not the sentence is grammatical for later use.
        grammer = !wordPlacement(line, syl2, rSylLine)
        #tweak the line for minor rules
        line = minorCorrection line
    end
    text = line
    if !$grammerCheck
        parser = Gingerice::Parser.new
        g = parser.parse text
        line = g["result"]
    end

    #There my be an extra " " at the end of the line. Get that outta there.
    return line.chomp(" ") + "."#<-- punctutation is integral to human comminication.
end

#MAIN STARTS HERE

#copies the File syl.txt to the var syl
syl = File.open("finalData.txt", "r")
#makes syl an array
syl = syl.each_line.to_a
#gets random # from 0 to the length of syl
rand = rand(0..syl.length)

runner = 0
syl2 = Array.new
#repeat until nothing left in syl
while runner < syl.length do
    #makes each index of syl2 and array of [word, syl_count]
    syl2[runner] = syl[runner].split("\t")
    runner = runner + 1
end

#############################################
#igore how many global variables I am using
col0 = syl2.map {|row| row[0]}.to_a
col1 = syl2.map {|row| row[1]}.to_a
col2 = syl2.map {|row| row[2]}.to_a
col3 = syl2.map {|row| row[3]}.to_a

$col = [col0, col1, col2, col3]

table = Hash[$col[0].zip($col[2])]
$listOfWordsWeightedOnFrequency = []
table.map do |word, freq|
    freq.to_i.times { $listOfWordsWeightedOnFrequency << word }
end

$sylsLookupTable = Hash[$col[0].zip($col[3])]
#############################################

count = 1
count.times do
    fline = makeLine 5, syl2, syl
    sline = makeLine 7, syl2, syl
    tline = makeLine 5, syl2, syl

    puts fline.capitalize()
    puts sline.capitalize()
    puts tline.capitalize()
end

puts "Ran for #{(Time.now - beginning)/count} seconds."