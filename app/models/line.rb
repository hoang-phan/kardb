class Line < ActiveRecord::Base
  belongs_to :song
  has_many :words

  default_scope -> { order(:position) }

  def to_s
    words.pluck(:content).join(' ')
  end
end
