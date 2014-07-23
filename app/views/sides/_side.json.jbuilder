json.extract! side, :power, :name, :status, :orderable
json.user side.user.login
json.user_side @side == side
json.creator @game.creator == side.user
