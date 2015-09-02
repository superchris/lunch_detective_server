defmodule MyOauth do
  defmodule Credentials do
    defstruct [:consumer_key, :consumer_secret,
               :token, :token_secret, method: :hmac_sha1]
  end

  alias :public_key, as: PKey

  def credentials(args) do
    struct(Credentials, args)
  end

  def sign(verb, url, params, %Credentials{} = creds) do
    params = protocol_params(params, creds)
    signature = signature(verb, url, params, creds)

    [{"oauth_signature", signature} | params]
  end

  def header(params) do
    {oauth_params, req_params} = Enum.partition(params, &protocol_param?/1)

    {{"Authorization", "OAuth " <> compose_header(oauth_params)}, req_params}
  end

  def protocol_params(params, %Credentials{} = creds) do
    [{"oauth_consumer_key",     creds.consumer_key},
     {"oauth_nonce",            nonce},
     {"oauth_signature_method", sign_method(creds.method)},
     {"oauth_timestamp",        timestamp},
     {"oauth_version",          "1.0"}
     | cons_token(params, creds.token)]
  end

  def signature(_, _, _, %{method: :plaintext} = creds) do
    compose_key(creds)
  end

  def signature(verb, url, params, %{method: :hmac_sha1} = creds) do
    :crypto.hmac(:sha, compose_key(creds), base_string(verb, url, params))
    |> Base.encode64
  end

  def signature(verb, url, params, %{method: :rsa_sha1} = creds) do
    base_string(verb, url, params)
    |> PKey.sign(:sha, read_private_key(creds.consumer_secret))
    |> Base.encode64
  end

  defp protocol_param?({key, _v}) do
    String.starts_with?(key, "oauth_")
  end

  defp compose_header([_ | _] = params) do
    Stream.map(params, &percent_encode/1)
    |> Enum.sort
    |> Enum.map_join(", ", &compose_header/1)
  end

  defp compose_header({key, value}) do
    key <> "=\"" <> value <> "\""
  end

  defp compose_key(creds) do
    [creds.consumer_secret, creds.token_secret]
    |> Enum.map_join("&", &percent_encode/1)
  end

  defp read_private_key(path) do
    File.read!(path)
    |> PKey.pem_decode
    |> hd |> PKey.pem_entry_decode
  end

  defp base_string(verb, url, params) do
    {base_url, q_params} = parse_url(url)
    base = [verb, base_url, normalize_params(params, q_params)]
      |> Enum.map_join("&", &percent_encode/1)
    param_map = Enum.into params, %{}
    # oauth_timestamp = param_map["oauth_timestamp"]
    # oauth_nonce = param
    IO.puts "base_string is #{base}"
    actual = "GET&http%3A%2F%2Fapi.yelp.com%2Fv2%2Fsearch&limit%3D16%26location%3DSan%2520Francisco%26oauth_consumer_key%3DoHIOcKmiG_wxWTxXAc95Iw%26oauth_nonce%3D#{param_map["oauth_nonce"]}%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D#{param_map["oauth_timestamp"]}%26oauth_token%3D0rSlHPN1wXjGNRsUVbNZpDIq929RAoMA%26oauth_version%3D1.0%26term%3Dtacos"
    IO.puts "should be #{actual}"
    base
  end

  defp normalize(verb) when is_binary(verb),
    do: String.upcase(verb)

  defp parse_url(url) do
    uri = URI.parse(url)
    {"#{uri.scheme}://#{uri.host}#{uri.path}", uri.query |> URI.decode_query |> Enum.into [] }
  end

  defp normalize_params(params, q_params) do
    Enum.concat(params, q_params)
    |> Enum.map(&percent_encode/1)
    |> Enum.sort
    |> Enum.map_join("&", &normalize/1)
  end

  defp normalize({key, value}) do
    key <> "=" <> value
  end

  defp nonce do
    :crypto.rand_bytes(16) |> Hexate.encode
    # "bba486ac64754ab57eb24004215e6cb5"
  end

  defp timestamp do
    {mgsec, sec, _mcs} = :os.timestamp

    mgsec * 1_000_000 + sec
  end

  defp cons_token(params, nil), do: params
  defp cons_token(params, value),
    do: [{"oauth_token", value} | params]

  defp sign_method(:plaintext), do: "PLAINTEXT"
  defp sign_method(:hmac_sha1), do: "HMAC-SHA1"
  defp sign_method(:rsa_sha1),  do: "RSA-SHA1"

  defp percent_encode({key, value}) do
    {percent_encode(key), percent_encode(value)}
  end

  defp percent_encode(term) do
    to_string(term) |> URI.encode(&URI.char_unreserved?/1)
  end
end
