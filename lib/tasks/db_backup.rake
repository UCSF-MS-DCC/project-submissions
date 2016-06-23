namespace :db_backup do 
	desc "backsup the production database"
	task :db_backup => :environment do 

		DatabaseMailer.backup_database.deliver
	end
end