# This is what we're using to backup the database from the server. 
class DatabaseMailer < ActionMailer::Base
  default from: "adam.santaniello@ucsf.edu"

  def backup_database
  	attachments['MSDR.sqlite3'] = File.read("#{Rails.root}/db/production.sqlite3")
  	mail(to: "adam.santaniello@ucsf.edu", subject: 'Weekly MSDR Database')
  end
end
