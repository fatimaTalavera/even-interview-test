# == Schema Information
#
# Table name: releases
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  released_at :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Release < ApplicationRecord
  has_one :album
  belongs_to :album
  has_many :artist_releases
  has_many :artists, through: :artist_releases
end
