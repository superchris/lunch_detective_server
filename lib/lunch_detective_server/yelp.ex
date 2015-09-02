defmodule LunchDetectiveServer.Yelp do

  def creds do
    consumer_key = "oHIOcKmiG_wxWTxXAc95Iw" #ENV['YELP_CONSUMER_KEY']
    consumer_secret = "qFQdTzXgsW9xBM7lzkdCaCec5nw" #ENV['YELP_CONSUMER_SECRET']
    token = "0rSlHPN1wXjGNRsUVbNZpDIq929RAoMA" #ENV['YELP_TOKEN']
    token_secret = "iMVkpvcHXgmZje-945AhdOj6rA8" #ENV['YELP_TOKEN_SECRET']
    MyOauth.credentials(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      token: token,
      token_secret: token_secret)
  end

  def search do
    url = "http://api.yelp.com/v2/search?limit=16&location=Cincinnati&term=enchiladas"
    params = MyOauth.sign("GET", url, [], creds)
    {other_header, req_params} = MyOauth.header(params)
    header = {"Authorization", "OAuth oauth_consumer_key=\"oHIOcKmiG_wxWTxXAc95Iw\", oauth_nonce=\"4dd957b023f31d43a6810ec7ad1338db\", oauth_signature=\"RycYnZf%2Ff5eXqrUSPuezqWJGFU0%3D\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1441218786\", oauth_token=\"0rSlHPN1wXjGNRsUVbNZpDIq929RAoMA\", oauth_version=\"1.0\""}
    IO.inspect header
    IO.inspect other_header
    HTTPoison.get(url, [other_header])
  end
end
