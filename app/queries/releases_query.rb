class ReleasesQuery
  DEFAULT_LIMIT = 10
  MAX_LIMIT = 100

  def initialize(params:, scope: Release.all, now: Time.zone.now)
    @params = params
    @scope = scope
    @now = now
  end

  def call
    scoped = apply_filter(@scope)
      .includes(:album, :artists)
      .order(:released_at)

    limit = normalized_limit
    page  = normalized_page

    total_count = scoped.except(:order).count
    total_pages = (total_count.to_f / limit).ceil

    records = scoped.limit(limit).offset((page - 1) * limit)

    {
      records: records,
      meta: {
        page: page,
        limit: limit,
        total_count: total_count,
        total_pages: total_pages,
        prev_page: page > 1 ? page - 1 : nil,
        next_page: page < total_pages ? page + 1 : nil
      }
    }
  end

  private

  def apply_filter(scope)
    case @params[:filter]
    when "past"
      scope.where("released_at <= ?", @now)
    when "upcoming"
      scope.where("released_at > ?", @now)
    else
      scope
    end
  end

  def normalized_page
    page = @params[:page].to_i
    page.positive? ? page : 1
  end

  def normalized_limit
    limit = @params[:limit].to_i
    limit = DEFAULT_LIMIT unless limit.positive?
    [limit, MAX_LIMIT].min
  end
end