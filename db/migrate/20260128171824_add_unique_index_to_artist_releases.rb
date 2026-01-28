class AddUniqueIndexToArtistReleases < ActiveRecord::Migration[7.0]
  def change
    add_index :artist_releases, %i[artist_id release_id], unique: true
  end
end
