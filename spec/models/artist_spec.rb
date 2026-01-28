# == Schema Information
#
# Table name: artists
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
RSpec.describe Artist do

  it "creates an artist" do
    expect { FactoryBot.create(:artist, name: "The Beatles") }
      .to change(Artist, :count).by(1)
  end
end
