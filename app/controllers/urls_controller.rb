# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    # recent 10 short urls
    @url = Url.new
    @urls = Url.all.order(created_at: :desc).limit(10)
  end

  def create
    url = Url.new(new_url_params)

    if url.save
      redirect_to urls_path, flash: { success: 'Successfully created' }
    else
      redirect_to urls_path, flash: { notice: url.errors.full_messages }
    end
  end

  def show
    @url = Url.find_by(short_url: params[:url])
    # implement queries

    if @url.present?
      # this could be on the model, but I think that's ok, for a show page and only three simple queries, yet
      @daily_clicks = daily_clicks
      @browsers_clicks = Click.group(:browser).count.to_a
      @platform_clicks = Click.group(:platform).count.to_a
    else
      # not a beautiful 404 page, but a 404 page
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end

  def visit
    url = Url.find_by(short_url: params[:short_url])
    if url.present?
      update_url_clicks_and_register_new_click(url)
      redirect_to url.original_url
    else
      # not a beautiful 404 page, but a 404 page
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end

  private

  def daily_clicks
    Click.group('clicks.created_at::date').count.map { |k, v| [k.strftime('%b %d, %Y'), v] }
  end

  def generate_short_url
    generated_short_url = helpers.base26
    generated_short_url = helpers.base26 while Url.where(short_url: generated_short_url).any?
    generated_short_url
  end

  def new_url_params
    url_params.merge({ short_url: generate_short_url })
  end

  def update_url_clicks_and_register_new_click(url)
    url.update(clicks_count: url.clicks_count + 1)
    url.clicks.create(platform: browser.platform.name, browser: browser.name)
  end

  def url_params
    params.require(:url).permit(:original_url)
  end
end
