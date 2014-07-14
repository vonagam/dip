json.array! @messages do |message|
  json.extract! message, :_id, :from, :to, :created_at, :is_public, :text
end
