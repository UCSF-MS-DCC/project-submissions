# This is the task that is called from the cronjob on the server to backup the DB.
namespace :db_backup do 
	desc "backsup the production database"
	task :db_backup => :environment do 

		DatabaseMailer.backup_database.deliver
	end
end