class AuthFail < Devise::FailureApp 
  protected 

  def redirect_url
    root_path 
  end
end
