# frozen_string_literal: true
module BatchFeedbackEnums
  extend ActiveSupport::Concern
  included do
    enum aroma_strength: {
      no_aroma: 1,
      weak_aroma: 2,
      enough_aroma: 3,
      strong_aroma: 4,
      too_much_aroma: 5
    }

    enum aroma_quality: {
      foul_aroma: 1,
      undesirable_aroma: 2,
      good_aroma: 3,
      better_aroma: 4,
      best_aroma: 5
    }

    enum flavor_strength: {
      no_flavor: 1,
      weak_flavor: 2,
      enough_flavor: 3,
      strong_flavor: 4,
      too_much_flavor: 5
    }

    enum flavor_quality: {
      foul_flabor: 1,
      undesirable_flavor: 2,
      good_flavor: 3,
      better_flavor: 4,
      best_flavor: 5
    }

    enum coloration: {
      too_light: 1,
      just_right: 2,
      too_dark: 3
    }

    enum thickness: {
      way_too_thin: 1,
      thin: 2,
      ideal_thickness: 3,
      thick: 4,
      too_thick: 5
    }

    enum chewiness: {
      too_soft: 1,
      not_chewy_enough: 2,
      tender_and_chewy: 3,
      slightly_hard: 4,
      hard_or_crunchy: 5
    }

    enum fibrousness: {
      no_fiber: 1,
      slightly_fibrous: 2,
      too_fibrous: 3
    }

    enum saltiness: {
      no_salt: 1,
      insufficient_salt: 2,
      ideal_saltiness: 3,
      too_salty: 4,
      unbearable_saltiness: 5
    }

    enum spiciness: {
      no_spice: 1,
      insufficient_spice: 2,
      ideal_spiciness: 3,
      too_spicy: 4,
      unbearable_spiciness: 5
    }

    enum piece_size: {
      tiny_pieces: 1,
      small_pieces: 2,
      ideal_piece_size: 3,
      large_pieces: 4,
      unacceptably_large: 5
    }

    enum quantity_impression: {
      quantity_seems_small: 1,
      quantity_looks_right: 2,
      quantity_looks_big: 3
    }

    enum appearance: {
      ugly: 1,
      looks_weird: 2,
      sufficiently_attractive: 3,
      looks_impressive: 4,
      exceptionally_attractive: 5
    }

    enum overall_impression: {
      foul: 1,
      unsellable: 2,
      undesirable: 3,
      ok: 4,
      snackable: 5,
      great: 6,
      omg_more_plz: 7
    }
  end
end
