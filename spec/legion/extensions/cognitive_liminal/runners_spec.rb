# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveLiminal::Runners::CognitiveLiminal do
  let(:engine) { Legion::Extensions::CognitiveLiminal::Helpers::LiminalEngine.new }
  let(:runner) do
    obj = Object.new
    obj.extend(described_class)
    obj.instance_variable_set(:@default_engine, engine)
    obj
  end

  describe '#begin_crossing' do
    it 'returns success with crossing hash' do
      result = runner.begin_crossing(origin: :analytical, destination: :creative, engine: engine)
      expect(result[:success]).to be true
      expect(result[:crossing][:origin]).to eq(:analytical)
    end
  end

  describe '#advance_crossing' do
    it 'returns success for known crossing' do
      crossing = engine.begin_crossing(origin: :analytical, destination: :creative)
      result = runner.advance_crossing(crossing_id: crossing.id, engine: engine)
      expect(result[:success]).to be true
    end

    it 'returns failure for unknown crossing' do
      result = runner.advance_crossing(crossing_id: 'bad', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '#dissolve_crossing' do
    it 'returns success for known crossing' do
      crossing = engine.begin_crossing(origin: :analytical, destination: :creative)
      result = runner.dissolve_crossing(crossing_id: crossing.id, engine: engine)
      expect(result[:success]).to be true
    end
  end

  describe '#crystallize_crossing' do
    it 'returns success for known crossing' do
      crossing = engine.begin_crossing(origin: :analytical, destination: :creative)
      result = runner.crystallize_crossing(crossing_id: crossing.id, engine: engine)
      expect(result[:success]).to be true
    end
  end

  describe '#active_crossings' do
    it 'returns active list' do
      engine.begin_crossing(origin: :analytical, destination: :creative)
      result = runner.active_crossings(engine: engine)
      expect(result[:count]).to eq(1)
    end
  end

  describe '#liminal_crossings' do
    it 'returns liminal list' do
      crossing = engine.begin_crossing(origin: :analytical, destination: :creative)
      5.times { crossing.advance! }
      result = runner.liminal_crossings(engine: engine)
      expect(result[:count]).to eq(1)
    end
  end

  describe '#fertile_crossings' do
    it 'returns fertile list' do
      engine.begin_crossing(origin: :analytical, destination: :creative)
      result = runner.fertile_crossings(engine: engine)
      expect(result[:count]).to eq(1)
    end
  end

  describe '#liminal_status' do
    it 'returns comprehensive status' do
      result = runner.liminal_status(engine: engine)
      expect(result[:success]).to be true
      expect(result).to include(:total_crossings, :liminal_density)
    end
  end
end
