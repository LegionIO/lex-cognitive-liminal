# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveLiminal
      module Helpers
        class LiminalEngine
          include Constants

          def initialize
            @crossings = {}
          end

          def begin_crossing(origin:, destination:, domain: :general, ambiguity: DEFAULT_AMBIGUITY)
            prune_completed
            crossing = ThresholdCrossing.new(origin: origin, destination: destination,
                                             domain: domain, ambiguity: ambiguity)
            @crossings[crossing.id] = crossing
            crossing
          end

          def advance_crossing(crossing_id:)
            crossing = @crossings[crossing_id]
            return nil unless crossing

            crossing.advance!
          end

          def dissolve_crossing(crossing_id:)
            crossing = @crossings[crossing_id]
            return nil unless crossing

            crossing.dissolve!
          end

          def crystallize_crossing(crossing_id:)
            crossing = @crossings[crossing_id]
            return nil unless crossing

            crossing.crystallize!
          end

          def active_crossings = @crossings.values.select { |c| c.status == :active }
          def completed_crossings = @crossings.values.select(&:incorporated?)
          def liminal_crossings = @crossings.values.select(&:liminal?)
          def fertile_crossings = @crossings.values.select(&:fertile?)
          def peak_crossings = @crossings.values.select(&:peak_liminality?)

          def crossings_by_domain(domain:)
            @crossings.values.select { |c| c.domain == domain.to_sym }
          end

          def average_ambiguity
            active = active_crossings
            return 0.0 if active.empty?

            (active.sum(&:ambiguity) / active.size).round(10)
          end

          def average_creative_potential
            active = active_crossings
            return 0.0 if active.empty?

            (active.sum(&:creative_potential) / active.size).round(10)
          end

          def liminal_density
            return 0.0 if @crossings.empty?

            (liminal_crossings.size.to_f / [@crossings.size, 1].max).clamp(0.0, 1.0).round(10)
          end

          def most_liminal(limit: 5) = @crossings.values.sort_by { |c| -c.ambiguity }.first(limit)

          def liminal_report
            {
              total_crossings:   @crossings.size,
              active_count:      active_crossings.size,
              liminal_count:     liminal_crossings.size,
              completed_count:   completed_crossings.size,
              fertile_count:     fertile_crossings.size,
              peak_count:        peak_crossings.size,
              average_ambiguity: average_ambiguity,
              average_potential: average_creative_potential,
              liminal_density:   liminal_density,
              most_liminal:      most_liminal(limit: 3).map(&:to_h)
            }
          end

          def to_h
            {
              total_crossings: @crossings.size,
              active:          active_crossings.size,
              liminal:         liminal_crossings.size,
              avg_ambiguity:   average_ambiguity,
              avg_potential:   average_creative_potential
            }
          end

          private

          def prune_completed
            return if @crossings.size < MAX_TRANSITIONS

            @crossings.reject! { |_, c| c.incorporated? }
          end
        end
      end
    end
  end
end
