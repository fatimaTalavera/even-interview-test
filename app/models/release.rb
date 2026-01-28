# == Schema Information
#
# Table name: releases
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  released_at :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  album_id    :bigint           not null
#
# Indexes
#
#  index_releases_on_album_id  (album_id)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#
class Release < ApplicationRecord
  belongs_to :album
  has_many :artist_releases, dependent: :destroy
  has_many :artists, through: :artist_releases

  validates :name, presence: true
  validates :released_at, presence: true
end
