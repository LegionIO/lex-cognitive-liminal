# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveLiminal
      module Runners
        module CognitiveLiminal
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          def begin_crossing(origin:, destination:, domain: :general, ambiguity: nil, engine: nil, **)
            eng = engine || @default_engine
            crossing = eng.begin_crossing(origin: origin, destination: destination, domain: domain,
                                          ambiguity: ambiguity || Helpers::Constants::DEFAULT_AMBIGUITY)
            { success: true, crossing: crossing.to_h }
          end

          def advance_crossing(crossing_id:, engine: nil, **)
            eng = engine || @default_engine
            crossing = eng.advance_crossing(crossing_id: crossing_id)
            return { success: false, error: 'crossing not found' } unless crossing

            { success: true, crossing: crossing.to_h }
          end

          def dissolve_crossing(crossing_id:, engine: nil, **)
            eng = engine || @default_engine
            crossing = eng.dissolve_crossing(crossing_id: crossing_id)
            return { success: false, error: 'crossing not found' } unless crossing

            { success: true, crossing: crossing.to_h }
          end

          def crystallize_crossing(crossing_id:, engine: nil, **)
            eng = engine || @default_engine
            crossing = eng.crystallize_crossing(crossing_id: crossing_id)
            return { success: false, error: 'crossing not found' } unless crossing

            { success: true, crossing: crossing.to_h }
          end

          def active_crossings(engine: nil, **)
            eng = engine || @default_engine
            crossings = eng.active_crossings
            { success: true, count: crossings.size, crossings: crossings.map(&:to_h) }
          end

          def liminal_crossings(engine: nil, **)
            eng = engine || @default_engine
            crossings = eng.liminal_crossings
            { success: true, count: crossings.size, crossings: crossings.map(&:to_h) }
          end

          def fertile_crossings(engine: nil, **)
            eng = engine || @default_engine
            crossings = eng.fertile_crossings
            { success: true, count: crossings.size, crossings: crossings.map(&:to_h) }
          end

          def liminal_status(engine: nil, **)
            eng = engine || @default_engine
            report = eng.liminal_report
            { success: true, **report }
          end
        end
      end
    end
  end
end
