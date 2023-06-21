class UsersRepository
  class << self
    def newUser
      @user = User.new
    end

    def createUser(user)
      @user = User.new(user)
      # isSaveUser = @user.save
    end
  end
end
