# frozen_string_literal: true

require 'securerandom'

module Legion
  module Extensions
    module CognitiveLiminal
      module Helpers
        class ThresholdCrossing
          include Constants

          attr_reader :id, :origin, :destination, :domain, :phase,
                      :ambiguity, :creative_potential, :progress,
                      :quality, :created_at, :ticks_in_liminal
          attr_accessor :status

          def initialize(origin:, destination:, domain: :general, ambiguity: DEFAULT_AMBIGUITY)
            @id = SecureRandom.uuid
            @origin = valid_state(origin, ORIGIN_STATES)
            @destination = valid_state(destination, DESTINATION_STATES)
            @domain = domain.to_sym
            @ambiguity = ambiguity.to_f.clamp(0.0, 1.0).round(10)
            @creative_potential = compute_creative_potential
            @progress = 0.0
            @phase = :separation
            @quality = :ambiguous
            @status = :active
            @ticks_in_liminal = 0
            @created_at = Time.now
          end

          def advance!
            return self if @status == :completed

            @ticks_in_liminal += 1
            @progress = (@progress + CRYSTALLIZATION_RATE).clamp(0.0, 1.0).round(10)
            update_phase!
            update_ambiguity!
            @creative_potential = compute_creative_potential
            self
          end

          def dissolve!
            @ambiguity = (@ambiguity + DISSOLUTION_RATE).clamp(0.0, 1.0).round(10)
            @creative_potential = compute_creative_potential
            @quality = :dissolving
            self
          end

          def crystallize!
            @ambiguity = (@ambiguity - AMBIGUITY_RESOLUTION).clamp(0.0, 1.0).round(10)
            @progress = (@progress + CRYSTALLIZATION_RATE).clamp(0.0, 1.0).round(10)
            @quality = :crystallizing
            update_phase!
            self
          end

          def complete!
            @status = :completed
            @phase = :incorporation
            @progress = 1.0
            @ambiguity = 0.0
            @quality = :crystallizing
            self
          end

          def liminal? = @phase == :margin && @status == :active
          def separated? = @phase == :separation
          def incorporated? = @status == :completed
          def peak_liminality? = @ambiguity >= LIMINAL_PEAK
          def fertile? = @creative_potential >= CREATIVE_POTENTIAL_PEAK

          def ambiguity_label = Constants.label_for(AMBIGUITY_LABELS, @ambiguity)
          def potential_label = Constants.label_for(POTENTIAL_LABELS, @creative_potential)
          def progress_label = Constants.label_for(PROGRESS_LABELS, @progress)

          def to_h
            {
              id:                 @id,
              origin:             @origin,
              destination:        @destination,
              domain:             @domain,
              phase:              @phase,
              ambiguity:          @ambiguity,
              creative_potential: @creative_potential,
              progress:           @progress,
              quality:            @quality,
              status:             @status,
              ticks_in_liminal:   @ticks_in_liminal,
              liminal:            liminal?,
              peak_liminality:    peak_liminality?,
              fertile:            fertile?,
              ambiguity_label:    ambiguity_label,
              potential_label:    potential_label,
              progress_label:     progress_label,
              created_at:         @created_at.iso8601
            }
          end

          private

          def compute_creative_potential
            peak_dist = (@ambiguity - CREATIVE_POTENTIAL_PEAK).abs
            (1.0 - peak_dist).clamp(0.0, 1.0).round(10)
          end

          def update_phase!
            if @progress >= INCORPORATION_THRESHOLD
              @phase = :incorporation
              complete!
            elsif @progress >= SEPARATION_THRESHOLD
              @phase = :margin
            end
          end

          def update_ambiguity!
            if @phase == :margin
              @ambiguity = (@ambiguity + AMBIGUITY_GROWTH).clamp(0.0, 1.0).round(10)
            elsif @phase == :incorporation
              @ambiguity = (@ambiguity - AMBIGUITY_RESOLUTION).clamp(0.0, 1.0).round(10)
            end
          end

          def valid_state(state, list)
            sym = state.to_sym
            list.include?(sym) ? sym : list.first
          end
        end
      end
    end
  end
end
