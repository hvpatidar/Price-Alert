module Api
  module V1
    class AlertsController < ApplicationController
      before_action :authenticate_user!

      def index
        alerts = current_user.alerts
        alerts = alerts.where(status: params[:status]) if params[:status].present?
        alerts = alerts.paginate(page: params[:page], per_page: 10)
        render json: alerts, status: :ok
      end

      def create
        alert = current_user.alerts.new(alert_params)
        if alert.save
          render json: alert, status: :created
        else
          render json: alert.errors, status: :unprocessable_entity
        end
      end

      def destroy
        alert = current_user.alerts.find(params[:id])
        alert.destroy
        head :no_content
      end

      private

      def alert_params
        params.require(:alert).permit(:coin, :target_price)
      end

      def authenticate_user!
        token = request.headers['Authorization'].to_s.split(' ').last
        payload = JWT.decode(token, Rails.application.secrets.jwt_secret_key).first
        @current_user = User.find(payload['user_id'])
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      rescue JWT::DecodeError
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end

      attr_reader :current_user
    end
  end
end
