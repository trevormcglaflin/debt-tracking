require 'date'

PAYMENT_FREQUENCY_TO_PAYMENT_FREQUENCY_IN_MONTHS_MAPPINGS = {
  "Annually" => 12,
  "Semi-Annually" => 6,
  "Quarterly" => 3,
  "Monthly" => 1
}

PAYMENT_FREQUENCY_TO_PAYMENTS_PER_YEAR_MAPPINGS = {
  "Annually" => 1,
  "Semi-Annually" => 2,
  "Quarterly" => 4,
  "Monthly" => 12
}

class LoanAmortization
  attr_reader :schedule

  def initialize(name, principal, annual_interest, loan_term_months, payment_frequency, start_date)
    @name = name
    @principal = principal
    @annual_interest = annual_interest / 100.0  # Convert annual interest rate to decimal
    @loan_term_months = loan_term_months
    @payment_frequency = payment_frequency
    @start_date = Date.parse(start_date)
    @schedule = []

    generate_amortization_schedule
  end

  def generate_amortization_schedule
    remaining_balance = @principal
    payment_frequency_in_months = PAYMENT_FREQUENCY_TO_PAYMENT_FREQUENCY_IN_MONTHS_MAPPINGS[@payment_frequency]
    payments_per_year = PAYMENT_FREQUENCY_TO_PAYMENTS_PER_YEAR_MAPPINGS[@payment_frequency]
    periodic_interest_rate = @annual_interest / payments_per_year
    payment = calculate_periodic_payment
    

    @schedule << {
      period: 0,
      date: @start_date,
      payment: "-",
      principal_payment: "-",
      interest_payment: "-",
      remaining_balance: sprintf("$%.2f", @principal)
    }


    (@loan_term_months / payment_frequency_in_months).times do |period|
      interest_payment = (remaining_balance * periodic_interest_rate).round(2)
      principal_payment = (payment - interest_payment).round(2)
      remaining_balance -= principal_payment

      @schedule << {
        period: period + 1,
        date: @start_date >> ((period + 1) * payment_frequency_in_months),
        payment: sprintf("$%.2f", payment),
        principal_payment: sprintf("$%.2f", principal_payment),
        interest_payment: sprintf("$%.2f", interest_payment),
        remaining_balance: sprintf("$%.2f", remaining_balance)
      }
    end
  end

  def calculate_periodic_payment
    n = case @payment_frequency
      when "Annually" then 1
      when "Semi-Annually" then 2
      when "Quarterly" then 4
      when "Monthly" then 12
      else
        raise ArgumentError, "Invalid payment frequency"
    end
    
    # Calculate the total loan term in years
    t = @loan_term_months / 12.0
    
    # Calculate the periodic payment (PMT)
    @principal * (@annual_interest / n) / (1 - (1 + @annual_interest / n)**(-n * t))
  end
end
