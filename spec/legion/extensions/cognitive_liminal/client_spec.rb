# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveLiminal::Client do
  subject(:client) { described_class.new }

  it 'responds to runner methods' do
    expect(client).to respond_to(:begin_crossing, :advance_crossing, :liminal_status)
  end

  it 'runs a full liminal lifecycle' do
    result = client.begin_crossing(origin: :analytical, destination: :creative, domain: :cognitive)
    crossing_id = result[:crossing][:id]

    5.times { client.advance_crossing(crossing_id: crossing_id) }
    client.dissolve_crossing(crossing_id: crossing_id)
    10.times { client.crystallize_crossing(crossing_id: crossing_id) }

    status = client.liminal_status
    expect(status[:total_crossings]).to eq(1)
  end
end
