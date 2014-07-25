json.crsf form_authenticity_token

json.user do
  json.partial! 'users/show', user: current_user if user_signed_in?
end
