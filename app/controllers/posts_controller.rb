class PostsController < ApplicationController
  before_action :set_post, only: %i[ show ]

  def index
    @pagy, @posts = pagy(Post.published.includes(:user).order(published_at: :desc), items: 10)
  end

  def show
  end

  private
    def set_post
      @post = Post.published.includes(:user).find_by!(slug: params[:slug])
    end
end
