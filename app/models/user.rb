class User < ActiveRecord::Base
  
  has_and_belongs_to_many :roles

  has_secure_password

  attr_accessible :login, :email, :password, :password_confirmation
  attr_accessible :role_ids, :active, :banned, :as => :admin

  validates :login, :presence => true,
                    :format => {:with => /\A[a-z\d\-]+\z/i},
                    :length => {:within => 4..20},
                    :uniqueness => {:case_sensitive => false}

  validates :email, :presence => true,
                    :format => {:with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
                    :uniqueness => {:case_sensitive => false}
  
  validates :password,   :presence => true,
                        :confirmation => true,
                        :length => {:within => 4..20}, :on => :create
                        
  validates :password_confirmation, :presence => true, 
                                    :length => {:within => 4..20}, :on => :create
  
  validates_length_of :password, :within => 4..20, :allow_blank => true, :on => :update
  validates_length_of :password_confirmation, :within => 4..20, :allow_blank => true, :on => :update

  before_create {generate_token(:auth_token)}
  before_create :set_default_role

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def self.find_by_login_or_email(login_or_email)
    where("login = ? OR email = ?", login_or_email, login_or_email).first
  end

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def set_default_role
    default_role = Role.find_by_name('registered')
    self.roles << default_role
  end

  def active?
    active
  end
  
  def banned?
    banned
  end
  
  def activate
    update_attribute('active', true)
    active?
  end

  def deactivate
    update_attribute('active', false)
    active?
  end
  
  def reset_perishable_token!
    generate_token(:perishable_token)
    save :validate => false
  end

  def has_role?(role_name)
    self.roles.each do |role|
      return true if role.name == role_name.to_s
    end
    false
  end
  
  def admin?
    has_role?(:admin)
  end

  def super_admin?
    has_role?(:super_admin)
  end

  def send_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end
  
  def reset_password_send!
    reset_perishable_token!
    Notifier.reset_password(self).deliver
  end

  def self.find_using_perishable_token(token, age = 0)
    return nil if token.blank?
    age = age.to_i

    conditions_sql = "perishable_token = ?"
    conditions_subs = [token]

    if column_names.include?("updated_at") && age > 0
      conditions_sql += " and updated_at > ?"
      conditions_subs << age.seconds.ago
    end

    where(conditions_sql, *conditions_subs).first
  end
end
