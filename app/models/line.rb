class Line < ActiveRecord::Base
  belongs_to :song
  has_many :words
end
