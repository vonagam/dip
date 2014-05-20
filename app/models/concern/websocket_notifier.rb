module WebsocketNotifier
  extend ActiveSupport::Concern
  
  #included do
  #module InstanceMethods

  module ClassMethods
    def triggers_websocket( event, &block )
      after_create do |object|
        block.call(object).each do |channel|
          WebsocketRails[channel].trigger event, object
        end
      end
    end
  end
end
