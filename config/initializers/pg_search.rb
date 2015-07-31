PgSearch.multisearch_options = {
  :using => {
    :tsearch => {:prefix => true, :dictionary => "english"},
    :trigram => {}
  },
  :order_within_rank => "updated_at DESC"
}