class ClaimMailer < ActionMailer::Base
  default from: "test@test.com"
 
  def claim_email(recipient, user, establishment)
    @user = user
    @establishment = establishment
    mail(to: recipient, subject: 'Someone wants to claim establishment ' + @establishment.id.to_s)
  end
end
