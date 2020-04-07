class Api::V1::WrongController < Api::V1::ApiController

    def wrong
        render json: {message: "Specified route does not exist"}, status: :not_found
    end
end
