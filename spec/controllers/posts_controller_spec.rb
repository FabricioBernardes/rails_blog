
require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user) }
  let!(:published_post) { create(:post, :published, user: user, title: "Published Title") }
  let!(:unpublished_post) { create(:post, :draft, user: user, title: "Unpublished Title") }

  describe 'GET /posts' do
    it 'shows only published posts in the response body' do
      get posts_path
      expect(response.body).to include("Published Title")
      expect(response.body).not_to include("Unpublished Title")
    end

    it 'orders posts by published_at desc in the response body' do
      older_post = create(:post, :published, published_at: 2.days.ago, user: user, title: "Older Post")
      newer_post = create(:post, :published, published_at: 1.day.ago, user: user, title: "Newer Post")
      get posts_path
      expect(response.body.index("Newer Post")).to be < response.body.index("Older Post")
    end
  end

  describe 'GET /posts/:slug' do
    it 'renders the published post by slug' do
      get post_path(slug: published_post.slug)
      expect(response.body).to include("Published Title")
    end

    it 'returns 404 for unpublished post' do
      get post_path(slug: unpublished_post.slug)
      expect(response).to have_http_status(:not_found)
    end
  end
end
