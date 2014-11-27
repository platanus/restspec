module Restspec
  module Requirements
    class Requirement
      attr_reader :name, :errors

      def initialize(name)
        self.name = name
        self.errors = []
        extend Restspec::RSpec::ApiHelpers
      end

      def execution(&execution_block)
        define_singleton_method(:execute, &execution_block)
      end

      def execute
      end

      def assert!
        execute
        if errors.any?
          raise errors.join(' | ')
        end
      end

      def add_error(error)
        errors << error
      end

      private

      attr_writer :name, :errors

      class << self
        attr_reader :requirements

        def get_or_create(name)
          find_by_name(name) || create(name)
        end

        def find_by_name(name)
          requirements.find { |r| r.name == name }
        end

        def create(name)
          self.new(name).tap { |r| requirements << r }
        end

        def requirements
          @requirements ||= []
        end

        private

        attr_writer :requirements
      end
    end
  end
end
