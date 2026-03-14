# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveLiminal::Helpers::LiminalEngine do
  subject(:engine) { described_class.new }

  describe '#begin_crossing' do
    it 'creates a threshold crossing' do
      crossing = engine.begin_crossing(origin: :analytical, destination: :creative)
      expect(crossing.origin).to eq(:analytical)
    end
  end

  describe '#advance_crossing' do
    it 'advances known crossing' do
      crossing = engine.begin_crossing(origin: :analytical, destination: :creative)
      engine.advance_crossing(crossing_id: crossing.id)
      expect(crossing.ticks_in_liminal).to eq(1)
    end

    it 'returns nil for unknown crossing' do
      expect(engine.advance_crossing(crossing_id: 'bad')).to be_nil
    end
  end

  describe '#dissolve_crossing' do
    it 'dissolves known crossing' do
      crossing = engine.begin_crossing(origin: :focused, destination: :diffuse)
      original = crossing.ambiguity
      engine.dissolve_crossing(crossing_id: crossing.id)
      expect(crossing.ambiguity).to be > original
    end
  end

  describe '#crystallize_crossing' do
    it 'crystallizes known crossing' do
      crossing = engine.begin_crossing(origin: :intuitive, destination: :deliberate)
      original = crossing.ambiguity
      engine.crystallize_crossing(crossing_id: crossing.id)
      expect(crossing.ambiguity).to be < original
    end
  end

  describe '#active_crossings' do
    it 'returns active crossings' do
      engine.begin_crossing(origin: :analytical, destination: :creative)
      expect(engine.active_crossings.size).to eq(1)
    end
  end

  describe '#completed_crossings' do
    it 'returns completed crossings' do
      crossing = engine.begin_crossing(origin: :analytical, destination: :creative)
      20.times { crossing.advance! }
      expect(engine.completed_crossings.size).to eq(1)
    end
  end

  describe '#liminal_crossings' do
    it 'returns crossings in margin phase' do
      crossing = engine.begin_crossing(origin: :analytical, destination: :creative)
      5.times { crossing.advance! }
      expect(engine.liminal_crossings.size).to eq(1)
    end
  end

  describe '#fertile_crossings' do
    it 'returns fertile crossings' do
      engine.begin_crossing(origin: :analytical, destination: :creative)
      expect(engine.fertile_crossings.size).to eq(1)
    end
  end

  describe '#crossings_by_domain' do
    it 'filters by domain' do
      engine.begin_crossing(origin: :analytical, destination: :creative, domain: :cognitive)
      engine.begin_crossing(origin: :focused, destination: :diffuse, domain: :emotional)
      expect(engine.crossings_by_domain(domain: :cognitive).size).to eq(1)
    end
  end

  describe '#average_ambiguity' do
    it 'returns 0.0 with no active crossings' do
      expect(engine.average_ambiguity).to eq(0.0)
    end

    it 'returns average for active crossings' do
      engine.begin_crossing(origin: :analytical, destination: :creative, ambiguity: 0.4)
      engine.begin_crossing(origin: :focused, destination: :diffuse, ambiguity: 0.6)
      expect(engine.average_ambiguity).to eq(0.5)
    end
  end

  describe '#average_creative_potential' do
    it 'returns 0.0 with no active crossings' do
      expect(engine.average_creative_potential).to eq(0.0)
    end
  end

  describe '#liminal_density' do
    it 'returns 0.0 with no crossings' do
      expect(engine.liminal_density).to eq(0.0)
    end
  end

  describe '#most_liminal' do
    it 'returns sorted by ambiguity descending' do
      engine.begin_crossing(origin: :analytical, destination: :creative, ambiguity: 0.3)
      high = engine.begin_crossing(origin: :focused, destination: :diffuse, ambiguity: 0.8)
      expect(engine.most_liminal(limit: 1).first.id).to eq(high.id)
    end
  end

  describe '#liminal_report' do
    it 'includes all report fields' do
      report = engine.liminal_report
      expect(report).to include(
        :total_crossings, :active_count, :liminal_count, :completed_count,
        :fertile_count, :peak_count, :average_ambiguity, :average_potential,
        :liminal_density, :most_liminal
      )
    end
  end

  describe '#to_h' do
    it 'includes summary fields' do
      hash = engine.to_h
      expect(hash).to include(:total_crossings, :active, :liminal, :avg_ambiguity, :avg_potential)
    end
  end
end
