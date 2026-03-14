# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveLiminal
      class Client
        include Runners::CognitiveLiminal

        def initialize
          @default_engine = Helpers::LiminalEngine.new
        end
      end
    end
  end
end
