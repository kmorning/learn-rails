module MyGoogleOauth2
  class Client
    def initialize(client_id, client_secret, client_refresh_token)
      @client_id = client_id
      @client_secret = client_secret
      @client_refresh_token = client_refresh_token
    end

    def access_token_valid?(access_token)
      response = ActiveSupport::JSON.decode(
        RestClient.post "https://www.googleapis.com/oauth2/v1/tokeninfo",
        access_token: access_token)
      # If we get a good response, verify the token has the correct audience.
      if response["audience"].present?
        response["audience"] == @client_id
      else
        false
      end
    rescue RestClient::BadRequest => e
      # Bad Request so we assume token is not valid
      false
    end

    def exchange_refresh_token
      data = {
        client_id: @client_id,
        client_secret: @client_secret,
        refresh_token: @client_refresh_token,
        grant_type: "refresh_token"
      }

      response = ActiveSupport::JSON.decode(
        RestClient.post "https://accounts.google.com/o/oauth2/token",
        data)
      if response["access_token"]
        response["access_token"]
      else
        nil
      end
    end

  end
end


