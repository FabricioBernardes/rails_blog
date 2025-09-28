module Admin
  class PostsController < ApplicationController
    before_action :authenticate_user!, except: [ :index, :show ]
    before_action :authorize_admin_or_author!
    before_action :set_post, only: %i[show edit update destroy]

    def index
      @posts = current_user.admin? ? Post.all : current_user.posts
    end

    def new
      @post = current_user.posts.new
    end

    def create
      @post = current_user.posts.new(post_params)
      if @post.save
        redirect_to admin_posts_path, notice: "Post created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize_post_owner! unless current_user.admin?
    end

    def update
      authorize_post_owner! unless current_user.admin?
      if @post.update(post_params)
        redirect_to admin_posts_path, notice: "Post updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize_post_owner! unless current_user.admin?
      @post.destroy
      redirect_to admin_posts_path, notice: "Post deleted successfully."
    end

    private

    def set_post
      slug_param = params[:slug] || params[:id]
      @post = Post.find_by(slug: slug_param)

      raise ActiveRecord::RecordNotFound, "Couldn't find Post with slug or id '#{slug_param}'" unless @post
    end

    def post_params
      params.require(:post).permit(:title, :body, :slug, :status, :published_at)
    end

    def authorize_admin_or_author!
      redirect_to root_path, alert: "Access denied." unless current_user.author? || current_user.admin?
    end

    def authorize_post_owner!
      redirect_to admin_posts_path, alert: "Access denied." unless @post.user == current_user
    end
  end
end
