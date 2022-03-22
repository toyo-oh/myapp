class ApplicationMailer < ActionMailer::Base
  default from: 'service@cf.com'
  layout 'mailer'
end
