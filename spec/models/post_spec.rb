require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { build(:post, :user) }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values(draft: 0, published: 1, archived: 2) }
  end

  describe "scopes" do
    describe ".published" do
      before do
        create(:post, status: :draft)
        create(:post, status: :published)
        create(:post, status: :archived)
        create(:post, status: :published)
      end

      it "returns only published posts" do
        expect(Post.published.count).to eq(2)
        expect(Post.published.all? { |post| post.status == "published" }).to be_truthy
      end
    end
  end

  describe "callbacks" do
    context "before_validation on create" do
      context "when slug is not provided" do
        it "generates a slug based on title" do
          post = build(:post, slug: nil, title: "Test Title")
          expect { post.save }.to change { post.slug }.from(nil).to("test-title")
        end

        it "ensures slug uniqueness by appending a counter" do
          create(:post, title: "Same Title", slug: "same-title")
          create(:post, title: "Same Title", slug: "same-title-2")

          post = build(:post, title: "Same Title", slug: nil)
          expect { post.save }.to change { post.slug }.from(nil).to("same-title-3")
        end
      end

      context "when slug is provided" do
        it "doesn't change the slug" do
          post = build(:post, slug: "custom-slug")
          expect { post.save }.not_to change { post.slug }
        end
      end

      context "when title is blank" do
        it "doesn't attempt to generate a slug" do
          post = build(:post, title: nil, slug: nil)
          post.save
          expect(post.slug).to be_nil
        end
      end
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      post = build_stubbed(:post, slug: "test-slug")
      expect(post.to_param).to eq("test-slug")
    end
  end

  describe "#generate_slug" do
    it "creates a parameterized version of the title" do
      post = build(:post, title: "This is a Test Title!", slug: nil)
      post.send(:generate_slug)
      expect(post.slug).to eq("this-is-a-test-title")
    end

    it "handles special characters and spaces properly" do
      post = build(:post, title: "Título com acentuação & símbolos!", slug: nil)
      post.send(:generate_slug)
      expect(post.slug).to eq("titulo-com-acentuacao-simbolos")
    end
  end
end
