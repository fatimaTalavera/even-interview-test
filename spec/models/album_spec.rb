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
RSpec.describe Album do

  it "creates an album" do
    artist = FactoryBot.create(:artist, name: "The Beatles")
    release = FactoryBot.create(:release, name: "Abbey Road")
    expect { FactoryBot.create(:album, artist: artist, release: release) }
      .to change(Album, :count).by(1)
  end
end
