# == Schema Information
#
# Table name: artist_releases
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  artist_id  :bigint           not null
#  release_id :bigint           not null
#
# Indexes
#
#  index_artist_releases_on_artist_id   (artist_id)
#  index_artist_releases_on_release_id  (release_id)
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => artists.id)
#  fk_rails_...  (release_id => releases.id)
#
FactoryBot.define do
  factory :artist_release do
    artist { create(:artist) }
    release { create(:release) }
  end
end
