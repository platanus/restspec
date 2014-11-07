module Restspec
  module Requirements
    class DSL
      def requirement(name, &definition)
        requirement = Requirement.get_or_create(name)
        requirement.instance_eval(&definition)
      end
    end
  end
end
