messages = @game.messages

if @game.status != 'finished'
  select = [ { is_public: true } ]
  select.push({ to: @side.power }, { from: @side.power }) if @side
  messages = messages.or *select
end

messages = messages.and({ :created_at.lt => @offset }) if @offset

messages = messages.desc(:created_at).limit(100).to_a

json.array! messages do |message|
  json.extract! message, :from, :to, :created_at, :is_public, :text
end
