class Word < ActiveRecord::Base
  default_scope -> { order(:processed_at) }
  belongs_to :line
end
