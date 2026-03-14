# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveLiminal::Helpers::ThresholdCrossing do
  subject(:crossing) { described_class.new(origin: :analytical, destination: :creative) }

  describe '#initialize' do
    it 'assigns a UUID id' do
      expect(crossing.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'stores origin' do
      expect(crossing.origin).to eq(:analytical)
    end

    it 'stores destination' do
      expect(crossing.destination).to eq(:creative)
    end

    it 'defaults to separation phase' do
      expect(crossing.phase).to eq(:separation)
    end

    it 'defaults ambiguity' do
      expect(crossing.ambiguity).to eq(0.5)
    end

    it 'starts with active status' do
      expect(crossing.status).to eq(:active)
    end

    it 'starts with 0 ticks' do
      expect(crossing.ticks_in_liminal).to eq(0)
    end

    it 'validates origin state' do
      bad = described_class.new(origin: :nonexistent, destination: :creative)
      expect(bad.origin).to eq(:analytical)
    end
  end

  describe '#advance!' do
    it 'increments ticks' do
      crossing.advance!
      expect(crossing.ticks_in_liminal).to eq(1)
    end

    it 'increases progress' do
      original = crossing.progress
      crossing.advance!
      expect(crossing.progress).to be > original
    end

    it 'transitions to margin phase' do
      5.times { crossing.advance! }
      expect(crossing.phase).to eq(:margin)
    end

    it 'eventually completes' do
      20.times { crossing.advance! }
      expect(crossing.incorporated?).to be true
    end

    it 'does not advance completed crossings' do
      20.times { crossing.advance! }
      ticks = crossing.ticks_in_liminal
      crossing.advance!
      expect(crossing.ticks_in_liminal).to eq(ticks)
    end
  end

  describe '#dissolve!' do
    it 'increases ambiguity' do
      original = crossing.ambiguity
      crossing.dissolve!
      expect(crossing.ambiguity).to be > original
    end

    it 'sets quality to dissolving' do
      crossing.dissolve!
      expect(crossing.quality).to eq(:dissolving)
    end
  end

  describe '#crystallize!' do
    it 'decreases ambiguity' do
      original = crossing.ambiguity
      crossing.crystallize!
      expect(crossing.ambiguity).to be < original
    end

    it 'increases progress' do
      original = crossing.progress
      crossing.crystallize!
      expect(crossing.progress).to be > original
    end

    it 'sets quality to crystallizing' do
      crossing.crystallize!
      expect(crossing.quality).to eq(:crystallizing)
    end
  end

  describe '#complete!' do
    it 'sets status to completed' do
      crossing.complete!
      expect(crossing.status).to eq(:completed)
    end

    it 'sets progress to 1.0' do
      crossing.complete!
      expect(crossing.progress).to eq(1.0)
    end

    it 'clears ambiguity' do
      crossing.complete!
      expect(crossing.ambiguity).to eq(0.0)
    end
  end

  describe '#liminal?' do
    it 'is false in separation' do
      expect(crossing.liminal?).to be false
    end

    it 'is true in margin phase' do
      5.times { crossing.advance! }
      expect(crossing.liminal?).to be true
    end
  end

  describe '#peak_liminality?' do
    it 'is true when ambiguity is high' do
      5.times { crossing.dissolve! }
      expect(crossing.peak_liminality?).to be true
    end
  end

  describe '#fertile?' do
    it 'detects creative potential peak' do
      expect(crossing.fertile?).to be true
    end
  end

  describe '#to_h' do
    it 'includes all fields' do
      hash = crossing.to_h
      expect(hash).to include(
        :id, :origin, :destination, :domain, :phase, :ambiguity,
        :creative_potential, :progress, :quality, :status,
        :ticks_in_liminal, :liminal, :peak_liminality, :fertile,
        :ambiguity_label, :potential_label, :progress_label, :created_at
      )
    end
  end
end
