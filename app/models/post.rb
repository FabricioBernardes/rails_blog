class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  enum :status, { draft: 0, published: 1, archived: 2 }

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    return if slug.present? || title.blank?

    self.slug = title.to_s.parameterize
  end
end
