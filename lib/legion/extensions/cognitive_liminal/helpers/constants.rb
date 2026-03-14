# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveLiminal
      module Helpers
        module Constants
          MAX_TRANSITIONS = 200
          MAX_THRESHOLDS = 100

          # Liminal dynamics
          DEFAULT_AMBIGUITY = 0.5
          AMBIGUITY_GROWTH = 0.08
          AMBIGUITY_RESOLUTION = 0.12
          CREATIVE_POTENTIAL_PEAK = 0.7
          DISSOLUTION_RATE = 0.05
          CRYSTALLIZATION_RATE = 0.07

          # Phase thresholds
          SEPARATION_THRESHOLD = 0.3
          LIMINAL_PEAK = 0.7
          INCORPORATION_THRESHOLD = 0.9

          TRANSITION_PHASES = %i[
            separation margin incorporation
          ].freeze

          ORIGIN_STATES = %i[
            analytical creative intuitive deliberate
            receptive focused diffuse dormant
          ].freeze

          DESTINATION_STATES = %i[
            analytical creative intuitive deliberate
            receptive focused diffuse dormant
          ].freeze

          LIMINAL_QUALITIES = %i[
            ambiguous fertile dissolving crystallizing
            betwixt chaotic generative suspended
          ].freeze

          AMBIGUITY_LABELS = {
            (0.8..)     => :maximally_liminal,
            (0.6...0.8) => :deeply_liminal,
            (0.4...0.6) => :liminal,
            (0.2...0.4) => :transitioning,
            (..0.2)     => :settled
          }.freeze

          POTENTIAL_LABELS = {
            (0.8..)     => :explosive,
            (0.6...0.8) => :high,
            (0.4...0.6) => :moderate,
            (0.2...0.4) => :low,
            (..0.2)     => :depleted
          }.freeze

          PROGRESS_LABELS = {
            (0.8..)     => :nearly_incorporated,
            (0.6...0.8) => :deep_margin,
            (0.4...0.6) => :peak_liminality,
            (0.2...0.4) => :early_separation,
            (..0.2)     => :pre_liminal
          }.freeze

          def self.label_for(labels, value)
            labels.each { |range, label| return label if range.cover?(value) }
            :unknown
          end
        end
      end
    end
  end
end
