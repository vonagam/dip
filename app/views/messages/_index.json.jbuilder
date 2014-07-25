messages = game.messages

if game.status != 'ended'
  select = [ { is_public: true } ]
  select.push({ to: side.power }, { from: side.power }) if side
  messages = messages.or *select
end

messages = messages.where({ :created_at.lt => offset }) if offset

messages = messages.desc(:created_at).limit(10).to_a

json.messages messages, partial: 'messages/message', as: :message
