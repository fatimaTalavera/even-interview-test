class AddAlbumToReleases < ActiveRecord::Migration[7.0]
  def change
    add_reference :releases, :album, null: false, foreign_key: true
  end
end
