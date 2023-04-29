class ApplicationController < ActionController::API
    rescue_from JWT::ExpiredSignature, with: :jwt_expired

  


    private 
    def sendResponse payload, isSuccessful, status
        if isSuccessful
            render json: {data: payload, successful: true}, status: status
        else
            render json: {message: payload, successful: false}, status: status
        end
    end

    def jwt_expired
        sendResponse "JWT token has expired", false , :unauthorized
    end
end
