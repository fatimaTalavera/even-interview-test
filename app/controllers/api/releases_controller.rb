class Api::ReleasesController < ApplicationController
  def index
    result = ReleasesQuery.new(
      params: params.permit(:filter, :page, :limit)
    ).call

    render json: {
      data: result[:records].map { |release| serialize_release(release) },
      pagination: result[:meta]
    }
  end

  def create
    # TODO:
  end

  private

  def serialize_release(release)
    {
      id: release.id,
      name: release.name,
      released_at: release.released_at.to_date,
      album: {
        id: release.album.id,
        name: release.album.name,
        duration_in_minutes: release.album.duration_in_minutes
      },
      artists: release.artists.map do |artist|
        {
          id: artist.id,
          name: artist.name
        }
      end
    }
  end  
end
