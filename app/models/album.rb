# == Schema Information
#
# Table name: albums
#
#  id                  :bigint           not null, primary key
#  duration_in_minutes :integer          default(0)
#  name                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  artist_id           :bigint
#
# Indexes
#
#  index_albums_on_artist_id  (artist_id)
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => artists.id)
#
class Album < ApplicationRecord
  belongs_to :artist
  has_many :releases, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :duration_in_minutes, presence: true, numericality: { greater_than: 0 }
end
