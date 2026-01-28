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
FactoryBot.define do
  factory :album do
    artist { create(:artist) }
    release { create(:release) }
    name { "Abbey Road - Vinyl" }
    duration_in_minutes { 47 }
  end
end
