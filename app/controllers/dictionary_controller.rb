class DictionaryController < ApplicationController

	def index
		Spreadsheet.client_encoding = 'UTF-8'
		book = Spreadsheet.open 'public/dictionary.xls'
		@epic_d_d = book.worksheet 0
		@source_documents = book.worksheet 'Source Documents'
	end
end
