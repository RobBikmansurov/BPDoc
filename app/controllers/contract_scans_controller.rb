# coding: utf-8
class ContractScansController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:edit, :new]
  before_action :set_contract_scan, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def show
  end

  def edit
    @contract = @contract_scan.contract if @contract_scan
  end

  def update
    @contract = @contract_scan.contract if @contract_scan
    if @contract_scan.update(contract_scan_params)
      redirect_to @contract, notice: 'Contract_scan name was successfully updated.'
      begin
        ContractMailer.update_contract(@contract, current_user).deliver    # оповестим ответсвенных об изменениях договора
      rescue  Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        flash[:alert] = "Error sending mail to contract owner"
      end
    else
      render action: 'edit'
    end
  end

  def destroy
    @contract = @contract_scan.contract if @contract_scan
    @contract_scan.destroy
    redirect_to contract_url(@contract), notice: 'Contract_scan was successfully destroyed.'
  end

  private

    def set_contract_scan
      if params[:id].present?
        @contract_scan = ContractScan.find(params[:id])
      else
        @contract = Contract.new
      end
    end

    def contract_scan_params
      params.require(:contract_scan).permit(:conntract_id, :name)
    end

    def record_not_found
      flash[:alert] = "Неверный #id, Скан договора не найден."
      redirect_to action: :index
    end

end