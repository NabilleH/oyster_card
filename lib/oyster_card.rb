require_relative 'journey'
require_relative 'station'

class OysterCard

  BALANCE_CAP = 90
  MINIMUM_FARE = 1

  attr_reader :balance, :journey, :entry_station, :journey_history

  def initialize
    @balance = 0
    @journey = nil
    @journey_history = []
  end

  def top_up(amount)
    @balance >=BALANCE_CAP ? raise("Maximum balance of #{BALANCE_CAP} reached") : @balance += amount
  end

  def touch_in(entry_station)
    raise "Fare exceeds available balance" if @balance < MINIMUM_FARE

    @journey = Journey.new(entry_station)
  end

  def touch_out(exit_station)
    deduct
    @journey.complete_journey(exit_station)
    @journey_history << @journey.full_journey
    @journey = nil
  end

  private

  def deduct
    @balance -= MINIMUM_FARE
  end

end
