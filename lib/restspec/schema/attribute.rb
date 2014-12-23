module Restspec
  module Schema
    # An attribute is a part of a schema. All attributes have a name and a type at least.
    # A type is an instance of a subclass of {Restspec::Schema::Types::BasicType} that keeps
    # information about what are valid instances of the attribute and can generate valid
    # instances of the attribute.
    #
    # @example
    #
    #   string_type = Types::StringType.new
    #   name_attr = Attribute.new(:name, type)
    #
    #   string_type.example_for(name_attr) # A random word
    #   string_type.valid?(name_attr, 1000) # false
    #   string_type.valid?(name_attr, 'John') # true
    #
    # @example With the :example option
    #
    #   string_type = Types::StringType.new
    #   name_attr = Attribute.new(:name, type, example: 'Example!')
    #
    #   string_type.example_for(name_attr) # Example!
    #
    class Attribute
      attr_reader :name, :type

      # Creates an attribute. It uses an identifier (name), an instance
      # of a subclass of {Restspec::Schema::Types::BasicType} and
      # the possible following set of options:
      #
      # - **example**: A callable object (eg: a lambda) that returns something.
      # - **for**: Defines what abilities this attributes has.
      #   This is an array of the symbols `:checks` and `:examples`. This option
      #   defaults to `[:checks, :examples]`, allowing the attribute to be used
      #   for run validations from {Checker#check!} and for generating examples from {SchemaExample#value}.
      #
      # @param name the name of the attribute
      # @param type an instance of a subclass of {Restspec::Schema::Types::BasicType} that
      #   works like the type of this attribute, allowing the type to generate examples and
      #   run validations based on this attribute.
      # @return A new instance of Attribtue.
      def initialize(name, type, options = {})
        self.name = name
        self.type = type
        self.example_override = options.fetch(:example, nil)
        self.allowed_abilities = options.fetch(:for, [:checks, :examples])
      end

      # The inner example in the attribute created calling the :example option
      # when generating examples.
      #
      # @return The inner example created using the :example option.
      def example
        @example ||= example_override
      end

      # @return [true, false] if the attribute has the ability to generate examples or not
      def can_generate_examples?
        allowed_abilities.include?(:examples)
      end

      # @return [true, false] if the attribute has the ability to be checked
      def can_be_checked?
        allowed_abilities.include?(:checks)
      end

      private

      attr_writer :name, :type
      attr_accessor :example_override, :allowed_abilities
    end
  end
end
