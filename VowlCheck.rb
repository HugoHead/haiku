class VowlCheck
	def startsWithVowel (str)
		if str.start_with? ('a')
			return true
		elsif str.start_with ('e')
			return true
		elsif str.start_with ('i')
			return true
		elsif str.start_with ('o')
			return true
		elsif str.start_with ('u')
			return true
		else
			return false
		end
	end
end