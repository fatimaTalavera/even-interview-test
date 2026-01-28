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
RSpec.describe Release do

  it "creates a release" do
    expect { FactoryBot.create(:release) }.to change(Release, :count).by(1)
  end
end
