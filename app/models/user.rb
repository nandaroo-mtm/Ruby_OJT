class User < ApplicationRecord
  has_secure_password validations: false

  validates :user_name, presence:  { message: "Name field can't be blank!" }
  validates :email, presence: { message: "Email field can't be blank!" },
                    uniqueness: { message: 'This email has already been taken!' }
  validates :password, confirmation: { message: "Password confirmation doesn't match!", case_sensitive: true},
                       length: { minimum: 6, too_short: '%<count>s characters is the minimum allowed' }
end
