json.array!(@bets) do |bet|
  json.extract! bet, :post_id, :user_id
  json.url bet_url(bet, format: :json)
end
