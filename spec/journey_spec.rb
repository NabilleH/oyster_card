require 'journey'

describe Journey do

  let(:station) { double :station, zone: 1}

  it 'has a penalty fare by default' do
    expect(subject.fare).to eq Journey::MAXIMUM_FARE
  end

  describe "#start_journey" do

    it 'it stores an entry station' do
      subject.start_journey(station)
      expect(subject.full_journey[:entry_station]).to eq station
    end
  end

  describe "#complete_journey" do

      it 'it stores an exit station' do
        subject.complete_journey(station)
        expect(subject.full_journey[:exit_station]).to eq station
      end
  end

  describe "#calc_fare" do

    context "Correct tap in and out jouney" do
      it "should charge the normal fare" do
        subject.full_journey[:entry_station] = station
        subject.full_journey[:exit_station] = station
        expect(subject.calc_fare).to eq Journey::MINIMUM_FARE
      end
    end

    context "Tapped IN without tapping out first" do

      it "returns a maximum fare if no entry station given" do
        subject.full_journey[:entry_station] = "NO TOUCH IN - Max fare charged"
        subject.full_journey[:exit_station] = station
        expect(subject.calc_fare).to eq Journey::MAXIMUM_FARE
      end
     end

     context "Tapped OUT without tapping in first" do

       it "returns a maximum fare if no exit station given" do
         subject.full_journey[:entry_station] = station
         subject.full_journey[:exit_station] = "NO TOUCH OUT - Max fare charged"
         expect(subject.calc_fare).to eq Journey::MAXIMUM_FARE
       end
     end
  end

end
