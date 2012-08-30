class Notifier < ActionMailer::Base
  
  default :from => "#{Configurable.email_from_name} <#{ActionMailer::Base.smtp_settings[:user_name]}>"

  def activation_instructions(user) 
    @account_activation_url = activate_account_url(user.perishable_token)
    
    mail(:to => user.email, :subject => "#{t('users.account_activation_email_title')}") do |format|
      format.text
    end
  end

  def reset_password(user)
  
    @reset_password_url = reset_password_url(user.perishable_token)
  
    mail(:to => user.email, :subject => "#{t('users.reset_password_email_title')}") do |format|
      format.text
    end
  end
end
