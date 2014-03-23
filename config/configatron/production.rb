# Override your default settings for the Production environment here.
# 
# Example:
#   configatron.file.storage = :s3

configatron.paypal_username = ENV["PAYPAL_USERNAME_DEV"]
configatron.paypal_pwd = ENV["PAYPAL_PWD_DEV"]
configatron.paypal_signature = ENV["PAYPAL_SIGNATURE_DEV"]