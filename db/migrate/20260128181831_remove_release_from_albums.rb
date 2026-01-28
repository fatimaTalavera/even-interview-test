class RemoveReleaseFromAlbums < ActiveRecord::Migration[7.0]
  def change
    remove_reference :albums, :release, null: false, foreign_key: true
  end
end
