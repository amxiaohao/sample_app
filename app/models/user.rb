class User < ApplicationRecord
  attr_accessor :remember_token
  attr_accessor :activation_token

  # before_save { self.email = email.downcase }
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name,     presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,    presence: true, length: { maximum: 256 },
                       format: { with: VALID_EMAIL_REGEX },
                       uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  has_secure_password

  class << self
    #返回指定字符串的哈希摘要
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    #生成base64字符串
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  #将生成的base64字符串转换成哈希摘要，并赋值给self.remember_digest
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  #浏览器中的remember_token转换成哈希与User中的哈希比较
  def authenticated?(remember_token)
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  #删除用户的remember_digest
  def forget
    self.update_attribute(:remember_digest, nil)
  end

  private

    def downcase_email
      self.email = self.email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end
    
end
