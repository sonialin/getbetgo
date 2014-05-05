# Override your default settings for the Development environment here.
# 
# Example:
#   configatron.file.storage = :local

configatron.paypal_username = ENV["PAYPAL_USERNAME_DEV"]
configatron.paypal_pwd = ENV["PAYPAL_PWD_DEV"]
configatron.paypal_signature = ENV["PAYPAL_SIGNATURE_DEV"]

configatron.facebook_appid = ENV["OAUTH_FACEBOOK_APPID_DEV"]
configatron.facebook_appsecret = ENV["OAUTH_FACEBOOK_APPSECRET_DEV"]