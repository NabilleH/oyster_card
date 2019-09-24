require 'oyster_card'

describe OysterCard do

  let(:station_a) { double :station_a }
  let(:station_b) { double :station_b }
  let(:journey) { {entry_station: station_a, exit_station: station_b } }

  before(:each) do
    subject.top_up(20)
  end

  describe "New card is issued to a customer" do
    it "The card should have a zero balance" do
      subject = OysterCard.new
      expect(subject.balance).to eq 0
    end
  end

  describe '#top up' do
    it 'adds money to the card and returns the card balance' do
      initial_amount = subject.balance
      topup_amount = 10
      subject.top_up(topup_amount)
      expect(subject.balance).to eq initial_amount + topup_amount
    end

    it 'caps the balance at BALANCE_CAP' do
      subject.top_up(OysterCard::BALANCE_CAP)
      expect{subject.top_up(1)}.to raise_error("Maximum balance of #{OysterCard::BALANCE_CAP} reached")
    end
  end

  describe "#touch_in" do
    it "should set the in journey status to true" do
      subject.top_up(90)
      subject.touch_in(station_a)
      expect(subject.journey).to_not be nil
    end

    it "raises an error if card does not have required minimum balance" do
      subject = OysterCard.new
      expect{subject.touch_in(station_a)}.to raise_error("Fare exceeds available balance")
    end

    it "stores tap in station as a variable" do
      subject.touch_in(station_a)
      expect(subject.journey.full_journey[:entry_station]).to eq station_a
    end

  end

  describe "#touch_out" do
    it "should set journey variable back to nil" do
      subject.touch_in(station_a)
      subject.touch_out(station_b)
      expect(subject.journey).to eq nil
    end

    it 'reduces card balance by minimum fare' do
      subject.top_up(10)
      subject.touch_in(station_a)
      expect{subject.touch_out(station_b)}.to change{subject.balance}.by(-OysterCard::MINIMUM_FARE)
    end

    it 'tapping out will reset entry station to nil' do
      subject.touch_in(station_a)
      subject.touch_out(station_b)
      expect(subject.entry_station).to eq nil
    end
  end

    it "should permantly store the complete journey just made when tapping out" do
    subject.touch_in(station_a)
    subject.touch_out(station_b)
    expect(subject.journey_history).to include journey
    end
end
