require_relative 'journey'
require_relative 'station'

class OysterCard

  MINIMUM_FARE = 1
  BALANCE_CAP = 90

  attr_reader :balance, :journey, :entry_station, :journey_history

  def initialize
    @balance = 0
    @journey = nil
    @journey_history = []
  end

  def top_up(amount)
    @balance >=BALANCE_CAP ? raise("Maximum balance of #{BALANCE_CAP} reached") : @balance += amount
  end

  def touch_in(current_station)
    raise "Fare exceeds available balance" if @balance < MINIMUM_FARE
    if @journey == nil
      @journey = Journey.new
      @journey.start_journey(current_station)
    else
      touch_in_error(current_station)
    end
  end

  def touch_in_error(current_station)
      @journey.complete_journey("NO TOUCH OUT - Max fare charged")
      @journey_history << @journey.full_journey
      @journey.calc_fare
      deduct(@journey.fare)
      @journey = Journey.new
      @journey.start_journey(current_station)
  end

  def touch_out(current_station)
    if @journey == nil
      touch_out_error(current_station)
    elsif @journey != nil
      @journey.complete_journey(current_station)
      @journey_history << @journey.full_journey
      @journey.calc_fare
      deduct(@journey.fare)
      @journey = nil
    end
  end

  def touch_out_error(current_station)
    @journey = Journey.new
    @journey.start_journey("NO TOUCH IN - Max fare charged")
    @journey.complete_journey(current_station)
    @journey_history << @journey.full_journey
    @journey.calc_fare
    deduct(@journey.fare)
    @journey = nil
  end

  private

  def deduct(fare)
    @balance -= fare
  end

end
