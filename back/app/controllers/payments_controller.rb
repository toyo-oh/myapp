class PaymentsController < ApplicationController
  before_action :require_login, only: %i[create find_by_user_id set_default]
  before_action :auth_check, only: %i[show update destroy]

  def create
    user_id = decode_user_id(params[:user_id])
    @payment = Payment.new(payment_params)
    @payment.user_id = user_id
    @payment.is_default = 1 unless Payment.exists?(user_id: user_id)
    if !@payment.save
      render response_unprocessable_entity(@payment.errors)
    else
      render json: { code: 'ok', message: 'added payment way successfully!' }
    end
  end

  def find_by_user_id
    user_id = decode_user_id(params[:user_id])
    @payments = Payment.where(user_id: user_id)
    render json: { payments: @payments.as_json(methods: %i[hashid user_hashid],
                                               except: %i[id
                                                          created_at updated_at]) }
  end

  def show
    @payment = auth_check
    render json: @payment.wrap_json_payment
  end

  def update
    @payment = auth_check
    if !@payment.update(payment_params)
      render response_unprocessable_entity(@payment.errors)
    else
      render json: { code: 'ok', message: 'updated payment Successfully!' }
    end
  end

  def destroy
    @payment = auth_check
    if !@payment.destroy
      render response_unprocessable_entity(@payment.errors)
    else
      render json: { code: 'ok', message: 'deleted payment Successfully!' }
    end
  end

  def set_default
    @new_payment = auth_check
    @old_payment = Payment.find(params[:old_id])
    Payment.transaction do
      @old_payment.update!(is_default: 0)
      @new_payment.update!(is_default: 1)
    end
    render json: { code: 'ok', message: 'set default payment way successfully!' }
  end

  private

  def payment_params
    params.permit(:holder_name, :card_number, :expiration_date, :security_code)
  end

  def auth_check
    if validate_user.blank?
      response_unauthorized
    else
      @payment = if params[:id].blank?
                   Payment.find(params[:hashid])
                 else
                   Payment.find(params[:id])
                 end
      if validate_user.id == @payment.user_id
        @payment
      else
        response_unauthorized
      end
    end
  end
end
