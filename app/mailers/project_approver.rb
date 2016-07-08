# This is not used yet, but is ready for use. Check lib/tasks/db_backup.rake for task to backup DB.
class ProjectApprover < ActionMailer::Base
  default from: "carpenito.t@gmail.com"

  def send_approval_email(project)
  	@project = project
  	mail( :to => "thomas.carpenito@ucsf.edu",
  		:subject => "MSDR Project Requiring Approval"
  		)
  end
end
