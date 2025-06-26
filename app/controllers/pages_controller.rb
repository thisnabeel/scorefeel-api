class PagesController < BaseController
  before_action :set_page, only: [:show, :update, :destroy]

  def index
    @pages = Page.includes(:pageable).ordered
    render json: @pages
  end

  def show
    render json: @page.as_json(include: [:bullet_points])
  end

  def create
    @page = Page.new(page_params)
    
    if @page.save
      render json: @page, status: :created
    else
      render json: { errors: @page.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @page.update(page_params)
      render json: @page
    else
      render json: { errors: @page.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @page.destroy
    head :no_content
  end

  def for_pageable
    pageable_type = params[:pageable_type].classify
    pageable_id = params[:pageable_id]
    
    @pages = Page.for_pageable(pageable_type, pageable_id).includes(:pageable).ordered
    
    render json: @pages
  rescue NameError
    render json: { error: "Invalid pageable type: #{params[:pageable_type]}" }, status: :bad_request
  end

  def by_slug
    @page = Page.find_by!(slug: params[:slug])
    render json: @page
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Page not found' }, status: :not_found
  end

  private

  def set_page
    @page = Page.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Page not found' }, status: :not_found
  end

  def page_params
    params.require(:page).permit(:title, :slug, :position, :level, :pageable_type, :pageable_id)
  end
end 