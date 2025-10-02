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
    existing_slugs = Post.where("slug LIKE ?", "#{base_slug}%").pluck(:slug)

    if !existing_slugs.include?(base_slug)
      unique_slug = base_slug
    else
      counter = 2
      loop do
        candidate = "#{base_slug}-#{counter}"
        unless existing_slugs.include?(candidate)
          unique_slug = candidate
          break
        end
        counter += 1
      end
    end

    self.slug = unique_slug
  end
end
