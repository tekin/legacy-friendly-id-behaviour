module FriendlyId
  module SequentialSlugs
    def resolve_friendly_id_conflict(candidates)
      candidate_slug = candidates.first
      candidate_slug + friendly_id_config.sequence_separator + next_sequence_number(candidate_slug).to_s
    end

    def next_sequence_number(candidate_slug)
      slug_conflicts(candidate_slug).count + 1
    end

    def slug_conflicts(candidate_slug)
      scope_for_slug_generator.
        where(conflict_query, candidate_slug, sequential_slug_matcher(candidate_slug)).
        order("LENGTH(#{friendly_id_config.slug_column}) ASC, #{friendly_id_config.slug_column} ASC")
    end

  private

    def conflict_query
      "#{friendly_id_config.slug_column} = ? OR #{friendly_id_config.slug_column} LIKE ?"
    end

    def sequential_slug_matcher(candidate_slug)
      # Underscores (matching a single character) and percent signs (matching
      # any number of characters) need to be escaped
      # (While this seems like an excessive number of backslashes, it is correct)
      "#{candidate_slug}#{friendly_id_config.sequence_separator}".gsub(/[_%]/, '\\\\\&') + '%'
    end
  end
end
