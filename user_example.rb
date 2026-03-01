class User
    attr_accessor :name, :email #these are properties of the user class, they are called attributes
    def initialize(attributes = {}) #this is a constructor method, it is called when we create a new user object. 
        @name = attributes[:name]
        @email = attributes[:email]
    end

    def formatted_email
        "#{@name} <#{@email}>"
    end
end