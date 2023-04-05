Clearance.configure do |config|
  config.routes = false
  config.password_strategy = Clearance::PasswordStrategies::BCrypt
  config.mailer_sender = 'reply@example.com'
  config.cookie_expiration = ->(_cookies) { 1.year.from_now.utc }
  config.cookie_name = 'remember_token'
  config.mailer_sender = 'site@example.com'
  config.rotate_csrf_on_sign_in = true
  config.redirect_url = '/'
end
