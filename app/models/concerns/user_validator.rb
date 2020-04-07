class UserValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless check_user(value)
            record.errors[attribute] << (options[:message] || "Invalid user id")
        end
    end

    private
        def check_user(user_id)
            begin
                @user = User.find(user_id)
                return true
            rescue StandardError => e
                return false
            end
        end
end