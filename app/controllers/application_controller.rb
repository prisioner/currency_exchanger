class ApplicationController < ActionController::API
  before_action :check_bearer_token

  private

  def check_bearer_token
    token = request.headers["Authorization"]&.split&.last

    unless token == AUTH_TOKEN
      render json: {error: "Auth token invalid"}, status: :forbidden
    end
  end
end
