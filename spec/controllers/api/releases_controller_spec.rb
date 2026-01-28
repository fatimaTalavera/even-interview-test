RSpec.describe Api::ReleasesController do

  describe "#index" do
    include ActiveSupport::Testing::TimeHelpers

    it "returns releases ordered by released_at asc with pagination metadata" do
      travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
        r1 = FactoryBot.create(:release, name: "B", released_at: Time.zone.parse("2026-01-12T12:00:00Z"))
        r2 = FactoryBot.create(:release, name: "A", released_at: Time.zone.parse("2026-01-11T12:00:00Z"))

        get :index, params: { page: 1, limit: 10 }

        expect(response.status).to eq(200)
        body = JSON.parse(response.body)

        expect(body["data"].map { |r| r["id"] }).to eq([r2.id, r1.id])
        expect(body["pagination"]).to include(
          "page" => 1,
          "limit" => 10,
          "total_count" => 2,
          "total_pages" => 1,
          "prev_page" => nil,
          "next_page" => nil
        )
      end
    end

    it "supports filter=past" do
      travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
        past = FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-09T12:00:00Z"))
        FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-11T12:00:00Z"))

        get :index, params: { filter: "past" }

        body = JSON.parse(response.body)
        expect(body["data"].map { |r| r["id"] }).to eq([past.id])
      end
    end

    it "supports filter=upcoming" do
      travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
        upcoming = FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-11T12:00:00Z"))
        FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-09T12:00:00Z"))

        get :index, params: { filter: "upcoming" }

        body = JSON.parse(response.body)
        expect(body["data"].map { |r| r["id"] }).to eq([upcoming.id])
      end
    end

    it "paginates with page/limit (default limit 10)" do
      travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
        releases = 3.times.map do |i|
          FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-11T12:00:0#{i}Z"))
        end

        get :index, params: { page: 2, limit: 2 }

        body = JSON.parse(response.body)
        expect(body["data"].map { |r| r["id"] }).to eq([releases[2].id])
        expect(body["pagination"]).to include(
          "page" => 2,
          "limit" => 2,
          "total_count" => 3,
          "total_pages" => 2,
          "prev_page" => 1,
          "next_page" => nil
        )
      end
    end
  end
end
