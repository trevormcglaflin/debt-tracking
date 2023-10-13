require_relative "../models/amortization_schedule"
require 'date'

class EntitiesController < ApplicationController
  def index
    @entities = Entity.all
  end

  def show
    @entity = Entity.find(params[:id])
    principal_data = get_principal_and_interest_data_for_entity(@entity.loans)
    @total_principal = principal_data[0]
    @total_principal_due_next_12_months = principal_data[1]
    @total_principal_previously_due = principal_data[2]
    @total_interest = principal_data[3]
    @total_interest_due_next_12_months = principal_data[4]
    @total_interest_previously_due = principal_data[5]

    @cash_flow_map = prepare_cash_flow_map(@entity.loans)
    puts 'here'
    puts @cash_flow_map
    
  end

  def new
    @entity = Entity.new
  end

  def create
    @entity = Entity.new(entity_params)

    if @entity.save
      redirect_to @entity
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @entity = Entity.find(params[:id])
  end

  def update
    @entity = Entity.find(params[:id])

    if @entity.update(entity_params)
      redirect_to @entity
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entity = Entity.find(params[:id])
    @entity.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def entity_params
      params.require(:entity).permit(:name, :email, :naics_code)
    end

    def get_principal_and_interest_data_for_entity(loans)
      now = DateTime.now
      one_year_from_today = now.next_year
      
      total_principal = 0
      total_principal_previously_due = 0
      total_principal_due_next_12_months = 0
      total_interest = 0
      total_interest_previously_due = 0
      total_interest_due_next_12_months = 0
      loans.each do |loan|
        total_principal += loan.principal
        amort_schedule = LoanAmortization.new(
          loan.name,
          loan.principal,
          loan.interest,
          loan.loan_term_in_months,
          loan.payment_frequency,
          loan.start_date.strftime("%Y-%m-%d")
        )
        amort_schedule.schedule.each do |row|
          total_interest += row[:interest_payment_num]
          row_date = row[:date]
          if row_date > now && row_date < one_year_from_today
            total_principal_due_next_12_months += row[:principal_payment_num]
            total_interest_due_next_12_months += row[:interest_payment_num]
          end
          if row_date < now
            total_principal_previously_due += row[:principal_payment_num]
            total_interest_previously_due += row[:interest_payment_num]
          end
        end
      end

      return [
        sprintf("$%.2f", total_principal),
        sprintf("$%.2f", total_principal_due_next_12_months),
        sprintf("$%.2f", total_principal_previously_due),
        sprintf("$%.2f", total_interest),
        sprintf("$%.2f", total_interest_due_next_12_months),
        sprintf("$%.2f", total_interest_previously_due)
      ]
    end


    def prepare_cash_flow_map(loans)
      now = DateTime.now
      date_list = [now]
      11.times do
        date_list.push(date_list[-1].next_month)
      end

      amort_schedules = []
      loans.each do |loan|
        amort_schedules.push(
          LoanAmortization.new(
            loan.name,
            loan.principal,
            loan.interest,
            loan.loan_term_in_months,
            loan.payment_frequency,
            loan.start_date.strftime("%Y-%m-%d")
          ).schedule
        )
      end
      
      cash_flow_map = {}
      date_list.each_with_index do |date, index|
        total_cash_flow_for_date_period = 0
        amort_schedules.each do |amort_schedule_rows|
          amort_schedule_rows.each do |row|
            if row[:date] > date && row[:date] <= date.next_month
              total_cash_flow_for_date_period += row[:payment_num]
            end
          end
        end
        cash_flow_map[date.strftime("%Y-%m-%d")] = total_cash_flow_for_date_period
      end
      return cash_flow_map
    end
end
