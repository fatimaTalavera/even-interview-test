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
#  release_id          :bigint
#
# Indexes
#
#  index_albums_on_artist_id   (artist_id)
#  index_albums_on_release_id  (release_id)
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => artists.id)
#  fk_rails_...  (release_id => releases.id)
#
class Album < ApplicationRecord
  belongs_to :release
  belongs_to :artist
  has_many :releases

  validates :name, presence: true, uniqueness: true
  validates :duration_in_minutes, presence: true, numericality: { greater_than: 0 }
end
