RSpec.describe "GET /api/releases", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  def parsed_body
    JSON.parse(response.body)
  end

  it "uses default limit of 10" do
    travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
      12.times { FactoryBot.create(:release) }

      get "/api/releases"

      body = parsed_body
      expect(response).to have_http_status(:ok)
      expect(body["data"].size).to eq(10)
      expect(body["pagination"]).to include(
        "page" => 1,
        "limit" => 10,
        "total_count" => 12,
        "total_pages" => 2,
        "next_page" => 2
      )
    end
  end

  it "respects custom limit" do
    travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
      5.times { FactoryBot.create(:release) }

      get "/api/releases", params: { limit: 3 }

      body = parsed_body
      expect(response).to have_http_status(:ok)
      expect(body["data"].size).to eq(3)
      expect(body["pagination"]).to include(
        "page" => 1,
        "limit" => 3,
        "total_count" => 5,
        "total_pages" => 2,
        "next_page" => 2
      )
    end
  end

  it "returns page 2 correctly" do
    travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
      releases = 5.times.map do |i|
        FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-11T12:00:0#{i}Z"))
      end

      get "/api/releases", params: { page: 2, limit: 2 }

      body = parsed_body
      expect(response).to have_http_status(:ok)
      expect(body["data"].map { |r| r["id"] }).to eq([releases[2].id, releases[3].id])
      expect(body["pagination"]).to include(
        "page" => 2,
        "limit" => 2,
        "total_count" => 5,
        "total_pages" => 3,
        "prev_page" => 1,
        "next_page" => 3
      )
    end
  end

  it "supports filter=past" do
    travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
      past = FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-09T12:00:00Z"))
      FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-11T12:00:00Z"))

      get "/api/releases", params: { filter: "past" }

      body = parsed_body
      expect(response).to have_http_status(:ok)
      expect(body["data"].map { |r| r["id"] }).to eq([past.id])
    end
  end

  it "supports filter=upcoming" do
    travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
      upcoming = FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-11T12:00:00Z"))
      FactoryBot.create(:release, released_at: Time.zone.parse("2026-01-09T12:00:00Z"))

      get "/api/releases", params: { filter: "upcoming" }

      body = parsed_body
      expect(response).to have_http_status(:ok)
      expect(body["data"].map { |r| r["id"] }).to eq([upcoming.id])
    end
  end

  it "includes album and artists in JSON" do
    travel_to(Time.zone.parse("2026-01-10T12:00:00Z")) do
      artist = FactoryBot.create(:artist, name: "Jane D")
      release = FactoryBot.create(:release, name: "Sound Music")
      FactoryBot.create(:artist_release, artist: artist, release: release)

      get "/api/releases"

      body = parsed_body
      expect(response).to have_http_status(:ok)
      item = body["data"].find { |r| r["id"] == release.id }
      expect(item["name"]).to eq("Sound Music")
      expect(item["album"]).to include("name")
      expect(item["artists"].map { |a| a["name"] }).to include("Jane D")
    end
  end
end


