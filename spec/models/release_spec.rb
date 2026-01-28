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
RSpec.describe Release do

  it "creates a release" do
    expect { FactoryBot.create(:release) }.to change(Release, :count).by(1)
  end
end
