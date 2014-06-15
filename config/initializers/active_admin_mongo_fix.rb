module Mongoid
  module Document
    def self.included(base)
      base.class_eval do
        def self.primary_key
          'id'
        end
      end
    end
  end
end

module ActiveAdmin
  module Filters
    module FormtasticAddons
      def klass
        @object.class
      end
 
      def polymorphic_foreign_type?(method)
        false
      end
    end
  end
end

module ActiveAdmin
  module ViewHelpers
    module DisplayHelper
      const_set :DISPLAY_NAME_FALLBACK, ->{
        name, klass = "", self.class
        name << klass.model_name.human         if klass.respond_to? :model_name
        #name << " ##{send(klass.primary_key)}" if klass.respond_to? :primary_key
        name.present? ? name : to_s
      }
    end
  end
end
