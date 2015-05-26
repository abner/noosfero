require "uri"

module Noosfero
  module API

    class Session < Grape::API

      # Login to get token
      #
      # Parameters:
      #   login (*required) - user login or email
      #   password (required) - user password
      #
      # Example Request:
      #  POST http://localhost:3000/api/v1/login?login=adminuser&password=admin
      post "/login" do
        user ||= User.authenticate(params[:login], params[:password], environment)

        return unauthorized! unless user
        user.generate_private_token!
        @current_user = user
        present user, :with => Entities::UserLogin
      end

      # Create user.
      #
      # Parameters:
      #   email (required)                  - Email
      #   password (required)               - Password
      #   login                             - login
      # Example Request:
      #   POST /register?email=some@mail.com&password=pas&login=some
      params do
        requires :email, type: String, desc: _("Email")
        requires :login, type: String, desc: _("Login")
        requires :password, type: String, desc: _("Password")
      end
      post "/register" do
        unique_attributes! User, [:email, :login]
        attrs = attributes_for_keys [:email, :login, :password]
        attrs[:password_confirmation] = attrs[:password]
        remote_ip = (request.respond_to?(:remote_ip) && request.remote_ip) || (env && env['REMOTE_ADDR'])
        private_key = API.NOOSFERO_CONF['api_recaptcha_private_key']
        api_recaptcha_verify_uri = API.NOOSFERO_CONF['api_recaptcha_verify_uri']
        verify_hash = {
          "secret"    => private_key,
          "remoteip"  => remote_ip,
          "response"  => params['g-recaptcha-response']
        }
        uri = URI(api_recaptcha_verify_uri)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data(verify_hash)
        captcha_result = JSON.parse(https.request(request).body)
        user = User.new(attrs)  
        if captcha_result["success"] and user.save! 
          user.activate
          user.generate_private_token!
          present user, :with => Entities::UserLogin
        else
          something_wrong!
        end
      end

    end
  end
end
