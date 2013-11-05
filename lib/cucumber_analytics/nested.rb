module CucumberAnalytics

  # A mix-in module containing methods used by elements that are nested inside
  # of other elements.

  module Nested

    # The parent object that contains *self*
    attr_accessor :parent_element


    # Returns the ancestor of *self* that matches the given type.
    def get_ancestor(ancestor_type)
      ancestor = self.parent_element
      target_type = {:directory => Directory,
                     :feature_file => FeatureFile,
                     :feature => Feature,
                     :test => TestElement,
                     :step => Step,
                     :table => Table,
                     :example => Example
      }[ancestor_type]

      raise(ArgumentError, "Unknown ancestor type '#{ancestor_type}'.") if target_type.nil?

      until ancestor.is_a?(target_type) || ancestor.nil?
        ancestor = ancestor.parent_element
      end

      ancestor
    end

  end
end
