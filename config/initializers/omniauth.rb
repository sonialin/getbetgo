Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV["OAUTH_FACEBOOK_APPID_DEV"], ENV["OAUTH_FACEBOOK_APPSECRET_DEV"], {
    secure_image_url: 'true',
    image_size: 'square'
  }
end