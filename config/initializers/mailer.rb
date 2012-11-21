ActionMailer::Base.default_url_options[:host] = CONFIG[:mailer_host]

unless Rails.env.test? 
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address        => CONFIG[:smtp_address],
    :domain         => CONFIG[:smtp_domain],
    :port           => CONFIG[:smtp_port],
    :user_name      => CONFIG[:smtp_user_name],
    :password       => CONFIG[:smtp_password].to_s,
    :authentication => CONFIG[:smtp_authentication].to_sym,
    :enable_starttls_auto => CONFIG[:smtp_enable_starttls_auto]
  }
else
  ActionMailer::Base.delivery_method = :test
end