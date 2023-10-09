require_relative "../models/amortization_schedule"

class LoansController < ApplicationController
  def create
    @entity = Entity.find(params[:entity_id])
    @loan = @entity.loans.create(loan_params)
    redirect_to entity_path(@entity)
  end

  def new
    @entity = Entity.find(params[:entity_id])
  end

  def show
    @entity = Entity.find(params[:entity_id])
    @loan = Loan.find(params[:id])

    @amortization_schedule = LoanAmortization.new(
      @loan.name,
      @loan.principal,
      @loan.interest,
      @loan.loan_term_in_months,
      @loan.payment_frequency,
      @loan.start_date.strftime("%Y-%m-%d")
    )
  end

  private
    def loan_params
      params.require(:loan).permit(
        :name,
        :commentary,
        :principal,
        :interest,
        :loan_term_in_months,
        :payment_frequency,
        :start_date
      )
    end
end
