module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: [ :show ]

      def index
        @pagy, @posts = pagy(Post.published.includes(:user).order(published_at: :desc), items: 5)
        render json: {
          posts: @posts.as_json(
            only: [ :id, :title, :slug, :published_at ],
            methods: [ :to_param ]
          ),
          pagination: {
            page: @pagy.page,
            items: @pagy.items,
            count: @pagy.count,
            pages: @pagy.pages
          }
        }
      end

      def show
        render json: @post.as_json(
          only: [ :id, :title, :body, :slug, :status, :published_at, :created_at, :updated_at ],
          include: {
            user: { only: [ :id, :email ] }
          }
        )
      end

      private

      def set_post
        @post = Post.published.includes(:user).find_by!(slug: params[:slug])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Post not found" }, status: :not_found
      end
    end
  end
end
