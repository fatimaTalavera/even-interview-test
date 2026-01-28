# == Schema Information
#
# Table name: artists
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Artist < ApplicationRecord
  has_many :albums
  has_many :artist_releases
  has_many :releases, through: :artist_releases

  validates :name, presence: true, uniqueness: true
end
