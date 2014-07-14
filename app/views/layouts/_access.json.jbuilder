json.user do
  if user_signed_in?
    json.extract! current_user, :login, :participated_games
  end
end

json.crsf form_authenticity_token
