class Api::ReleasesController < ApplicationController
  def index
    result = ReleasesQuery.new(
      params: params.permit(:filter, :page, :limit)
    ).call

    render json: {
      links: {
        self: api_releases_url
      },
      data: result[:records].map { |release| serialize_release(release) },
      included: result[:records].map { |release| serialize_album(release.album) }.compact + result[:records].map { |release| serialize_artists(release.artists) }.compact,
      pagination: result[:meta]
      }
  end

  def create
    # TODO:
  end

  private

  def serialize_release(release)
    {
      type: "release",
      id: release.id.to_s,
      attributes: {
        name: release.name,
        released_at: release.released_at.to_date
      },
      relationships: {
        album: {
          links: {
            self: "self_link",
            related: "api_album_url(release.album)"
          },
          data: release.album.present? ? {
            type: "albums",
            id: release.album.id.to_s
          } : nil
        },
        artists: {
          links: {
            self: "self_link",
            related: "api_release_artists_url(release)"
          },
          data: release.artists.map { |artist| { type: "artists", id: artist.id.to_s } }
        }
      },
      links: {
        self: "api_release_url(release)"
      }
    }
  end  

  def serialize_album(album)
    {
      type: "album",
      id: album.id.to_s,
      attributes: {
        name: album.name,
        duration_in_minutes: album.duration_in_minutes
      }
    }
  end

  def serialize_artists(artists)
    artists.map { |artist| { type: "artist", id: artist.id.to_s, attributes: { name: artist.name } } }
  end
end
