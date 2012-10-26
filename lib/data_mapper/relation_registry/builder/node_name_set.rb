module DataMapper
  class RelationRegistry
    class Builder

      # Set of relation names for a given relationship
      #
      class NodeNameSet
        include Enumerable

        # @api private
        def initialize(relationship, registry)
          @relationship, @registry = relationship, registry
        end

        # @api private
        def each(&block)
          to_enum unless block_given?
          names.each(&block)
          self
        end

        # @api private
        def last
          to_a.last
        end

        # @api private
        def names(relationships = relationship_map, joins = [])
          relationships.each do |right, left|
            if left.is_a?(Hash)
              joins << NodeName.new(names(left, joins)[joins.size-1], right)
            else
              joins << NodeName.new(left, right)
            end
          end

          joins
        end

        # @api private
        def relationship_map(relationship = @relationship, registry = @registry, map = {})
          name             = relationship.name
          via_relationship = registry[relationship.via]

          if via_relationship.via
            map[name] = {}
            relationship_map(via_relationship, registry, map[name])
          else
            map.merge!(name => via_relationship.name)
          end

          map
        end
      end

    end # class Builder
  end # class RelationRegistry
end # module DataMapper