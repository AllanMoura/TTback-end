class DateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless check_date(value)
            record.errors[attribute] << (options[:message] || "invalid Date, must be higher than current day.")
        end
    end

    private
        def check_date(date)
            currentDate  = nil
            
            if (date.class == DateTime || date.class == ActiveSupport::TimeWithZone)
                currentDate = date.to_date
            elsif (date.class == Date)
                currentDate = date
            else
                return false
            end

            if (currentDate <= Date.current)
                return false
            end

            return true
        end
end