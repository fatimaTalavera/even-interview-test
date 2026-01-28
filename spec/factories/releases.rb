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
FactoryBot.define do
  factory :release do
    name { "Abbey Road" }
    released_at { Time.zone.now }
  end
end
