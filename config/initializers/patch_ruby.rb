class Object
  def method_missing( method_name, *args )
    if /^not_(.+)$/ =~ method_name && respond_to?($1)
      block = proc { | *arguments | ! self.send($1,*arguments) }
      
      method($1.to_sym).owner.send( :define_method, method_name, block )
      
      puts 'undefined'
      
      return send( method_name, *args )
    end
    
    super
  end
end
