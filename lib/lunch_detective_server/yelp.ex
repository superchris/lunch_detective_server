defmodule LunchDetectiveServer.Yelp do

  def creds do
    consumer_key = "oHIOcKmiG_wxWTxXAc95Iw" #ENV['YELP_CONSUMER_KEY']
    consumer_secret = "qFQdTzXgsW9xBM7lzkdCaCec5nw" #ENV['YELP_CONSUMER_SECRET']
    token = "0rSlHPN1wXjGNRsUVbNZpDIq929RAoMA" #ENV['YELP_TOKEN']
    token_secret = "iMVkpvcHXgmZje-945AhdOj6rA8" #ENV['YELP_TOKEN_SECRET']
    %{
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      token: token,
      token_secret: token_secret
    }
  end

  def search do
    Exyelp.search %{term: "Chili", location: "Cincinnati"}, creds
  end
end