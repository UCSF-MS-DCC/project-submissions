# This is not used yet, but is ready for use. Check lib/tasks/db_backup.rake for task to backup DB.
class ProjectApprover < ActionMailer::Base
  default from: "adam.santaniello@ucsf.edu"

  def send_approval_email(project)
  	@project = project
  	mail( :to => "adam.santaniello@ucsf.edu",
  		:subject => "MSDR Project Requiring Approval"
  		)
  end
end
