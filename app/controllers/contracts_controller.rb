# coding: utf-8
class ContractsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :approval_sheet]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  autocomplete :bproce, :name, :extra_data => [:id]

  def index
    @contracts = Contract.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
  end

  def show
    @subcontracts = Contract.where("lft>? and rgt<?", @contract.lft, @contract.rgt).order("lft")
  end

  def new
    @contract = Contract.new
    @contract.date_begin = Date.today
    @contract.status = "Согласование"
  end

  def edit
    @bproce_contract = @contract.bproce_contract.new # заготовка для новой связи с процессом
  end

  def create
    @contract = Contract.new(contract_params)

    if @contract.save
      redirect_to @contract, notice: 'Contract was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @contract.update(contract_params)
      redirect_to @contract, notice: 'Contract was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @contract.destroy
    redirect_to contracts_url, notice: 'Contract was successfully destroyed.'
  end

  def approval_sheet
      approval_sheet_odt
  end

  def autocomplete
    @contracts = Contract.order(:number).where("name ilike ? or number ilike ?", "%#{params[:term]}%", "%#{params[:term]}%")
    render json: @contracts.map(&:autoname)
  end

  private

    def approval_sheet_odt    # Лист согласования
      report = ODFReport::Report.new("reports/approval-sheet-contract.odt") do |r|
        r.add_field "REPORT_DATE", Date.today.strftime('%d.%m.%Y')
        r.add_field "REPORT_DATE1", (Date.today + 10.days).strftime('%d.%m.%Y')
        r.add_field :id, @contract.id
        r.add_field :number, @contract.number
        r.add_field :name, @contract.name
        r.add_field :description, @contract.description
        r.add_field :owner, @contract.owner_name
        if !@contract.agent.town.blank?
          r.add_field :agent, @contract.agent_name + ', г. ' + @contract.agent.town
        else
          r.add_field :agent, @contract.agent_name
        end
        rr = 0
        if !@contract.bproce.blank?  # есть ссылки из документа на другие процессы?
          r.add_field :bp, "Относится к процессам:"
          r.add_table("BPROCS", @contract.bproce_contract.all, :header => false, :skip_if_empty => true) do |t|
            t.add_column(:rr) do |n1| # порядковый номер строки таблицы
              rr += 1
            end
            t.add_column(:process_name) do |bp|
              bp.bproce.name
            end
            t.add_column(:process_id) do |bp|
              bp.bproce.id
            end
            t.add_column(:process_owner) do |bp|
              bp.bproce.user_name
            end
          end
        else
          r.add_field :bp, "Процесс не назначен!"
        end
        #r.add_field "ORDERNUM", Date.today.strftime('%Y%m%d-с') + @usr.id.to_s
        #r.add_field :displayname, @usr.displayname
        r.add_field :user_position, current_user.position
        r.add_field "USER_NAME", current_user.displayname
      end
      report_file_name = report.generate
      send_file(report_file_name,
        :type => 'application/msword',
        :filename => "approval-sheet.odt",
        :disposition => 'inline' )
    end

    def set_contract
      @contract = Contract.find(params[:id])
    end

    def contract_params
      params.require(:contract).permit(:owner_id, :owner_name, :number, :name, :status, :date_begin, :date_end, :description, :text, :note, :condition, :check, :agent_id, :agent_name, :parent_id, :parent_name)
    end

    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "asc"
    end

  def record_not_found
    flash[:alert] = "Неверный #id, Договор не найден."
    redirect_to action: :index
  end


end