module FriendlyId
  module SequentialSlugs
    def resolve_friendly_id_conflict(candidates)
      SequentialSlugResolver.new(scope_for_slug_generator,
                                 candidates.first,
                                 friendly_id_config.slug_column,
                                 friendly_id_config.sequence_separator).next_slug
    end
  end

  class SequentialSlugResolver
    attr_accessor :scope, :clashing_slug, :slug_column, :sequence_separator

    def initialize(scope, clashing_slug, slug_column, sequence_separator)
      @scope = scope
      @clashing_slug = clashing_slug
      @slug_column = slug_column
      @sequence_separator = sequence_separator
    end

    def next_slug
      clashing_slug + sequence_separator + next_sequence_number.to_s
    end

  private

    def next_sequence_number
      if last_sequence_number == 0
        2
      else
        last_sequence_number + 1
      end
    end

    def last_sequence_number
      slug_conflicts.last.split("#{clashing_slug}#{sequence_separator}").last.to_i
    end

    def slug_conflicts
      scope.
        where(conflict_query, clashing_slug, sequential_slug_matcher).
        order(ordering_query).pluck(slug_column)
    end

    def conflict_query
      "#{slug_column} = ? OR #{slug_column} LIKE ?"
    end

    def sequential_slug_matcher
      # Underscores (matching a single character) and percent signs (matching
      # any number of characters) need to be escaped
      # (While this seems like an excessive number of backslashes, it is correct)
      "#{clashing_slug}#{sequence_separator}".gsub(/[_%]/, '\\\\\&') + '%'
    end

    def ordering_query
      "LENGTH(#{slug_column}) ASC, #{slug_column} ASC"
    end
  end
end
