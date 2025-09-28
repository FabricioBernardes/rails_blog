class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  enum :status, { draft: 0, published: 1, archived: 2 }

  scope :published, -> { where(status: :published) }

  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  private

  def generate_slug
    return if slug.present? || title.blank?

    base_slug = title.to_s.parameterize
    unique_slug = base_slug
    counter = 2

    while Post.exists?(slug: unique_slug)
      unique_slug = "#{base_slug}-#{counter}"
      counter += 1
    end

    self.slug = unique_slug
  end
end
