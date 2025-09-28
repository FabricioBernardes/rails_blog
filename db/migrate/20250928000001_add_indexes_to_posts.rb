class AddIndexesToPosts < ActiveRecord::Migration[8.0]
  def change
    add_index :posts, :slug, unique: true
    add_index :posts, :status
    add_index :posts, :published_at
  end
end
