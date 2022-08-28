class Currency < ApplicationRecord
  IGNORED_ISO_CODES = %w[
    VEF_BLKMKT VEF_DICOM VEF_DIPRO
    XAF XAG XAU XCD XDR XMR XOF XPD XPF XPT XRP
  ].freeze

  validates :iso, presence: true, exclusion: { in: IGNORED_ISO_CODES }
  validates :name, presence: true
  validates :rate, presence: true
end
