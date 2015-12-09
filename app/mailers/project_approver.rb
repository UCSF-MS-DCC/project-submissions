class ProjectApprover < ActionMailer::Base
  default from: "carpenito.t@gmail.com"

  def send_approval_email(project)
  	@project = project
  	mail( :to => "thomas.carpenito@ucsf.edu",
  		:subject => "MSDR Project Requiring Approval"
  		)
  end
end
