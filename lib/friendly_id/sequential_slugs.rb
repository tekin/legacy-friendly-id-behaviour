module FriendlyId
  # Module that patches friendly_id to produce sequentially numbered slugs.
  # This replicates the behaviour of v4 instead of the new default behaviour in
  # v5, which is to append a GUID to a conflicted slug.
  module SequentialSlugs
    def resolve_friendly_id_conflict(candidate_slugs)
      SequentialSlugGenerator.new(scope_for_slug_generator,
                                 candidate_slugs.first,
                                 friendly_id_config.slug_column,
                                 friendly_id_config.sequence_separator).generate
    end
  end
end
