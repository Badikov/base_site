authorization do
  
  role :guest do
    
    has_permission_on :front_users, :to =>  [:new, :create, :signup_complete, :activate, :forgot_password, :forgot_password_lookup_email, :reset_password, :reset_password_submit] 
    has_permission_on :front_sessions, :to => [:new, :create]
    
    has_permission_on :admin_home, :to => [:login]
  end

  role :registered do

    has_permission_on :front_users, :to => [:edit, :update, :destroy] do
      if_attribute :id => is {user.id}
    end
    
    has_permission_on :front_sessions, :to => [:destroy]
    
  end

  role :admin do
    has_omnipotence
  end
  
  role :super_admin do
    has_omnipotence
  end

end

