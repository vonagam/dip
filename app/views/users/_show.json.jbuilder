json.partial! 'users/user', user: user
json.extract! user, :participated_games
