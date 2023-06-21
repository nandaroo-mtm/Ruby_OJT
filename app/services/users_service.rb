class UsersService
  class << self
    def newUser
      @user = UsersRepository.newUser
    end

    def createUser(user)
      @user = UsersRepository.createUser(user)
    end
  end
end
