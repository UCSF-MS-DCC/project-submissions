# Controller used for managing the data dictionary at '/dictionary'
class DictionaryController < ApplicationController

	# Method for parsing Adam's data Dictionary, storing the rows in an instance variable
	def index
		Spreadsheet.client_encoding = 'UTF-8'
		book = Spreadsheet.open 'public/dictionary.xls'
		@epic_d_d = book.worksheet 0
	end
end
