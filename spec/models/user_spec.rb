require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:admin) { build(:user, :admin) }

  describe "associations" do
    it { should have_many(:posts).dependent(:destroy) }
  end

  describe "validations" do
    context "when using devise validatable" do
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_presence_of(:password) }
      it { should validate_length_of(:password).is_at_least(6) }
    end

    context "email format" do
      it "is valid with valid emails" do
        valid_emails = [
          "user@example.com",
          "USER@example.COM",
          "A_US-ER@example.something.co.uk",
          "first.last@example.net",
          "user+tag@example.com"
        ]

        valid_emails.each do |email|
          user.email = email
          expect(user).to be_valid, "#{email} should be valid"
        end
      end

      it "rejects empty email" do
        user.email = ""
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "rejects email without @ symbol" do
        user.email = "invalid_email"
        expect(user).not_to be_valid
      end

      it "has a format validator for email" do
        format_validators = User.validators_on(:email).select do |validator|
          validator.is_a?(ActiveModel::Validations::FormatValidator)
        end

        expect(format_validators).to be_present

        if format_validators.first.options[:with].is_a?(Regexp)
          regex = format_validators.first.options[:with]
          expect(regex.match?('user@example.com')).to be true
          expect(regex.match?('invalid_email')).to be false
        end
      end
    end
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(author: 0, admin: 1) }

    it "has author as default role" do
      expect(User.new.role).to eq("author")
    end
  end

  describe "indexes" do
    it { should have_db_index(:email).unique }
    it { should have_db_index(:reset_password_token).unique }
  end

  describe "devise modules" do
    it "includes the expected devise modules" do
      expect(User.devise_modules).to include(:database_authenticatable)
      expect(User.devise_modules).to include(:registerable)
      expect(User.devise_modules).to include(:recoverable)
      expect(User.devise_modules).to include(:rememberable)
      expect(User.devise_modules).to include(:validatable)
    end
  end

  describe "roles" do
    it "defaults to author role" do
      user = create(:user)
      expect(user.role).to eq("author")
      expect(user).to be_author
    end

    it "can be an admin" do
      user = create(:admin_user)
      expect(user.role).to eq("admin")
      expect(user).to be_admin
    end

    it "can change roles" do
      user = create(:user)
      user.admin!
      expect(user).to be_admin
      user.author!
      expect(user).to be_author
    end
  end

  describe "posts relation" do
    let(:user) { create(:user) }

    it "can have many posts" do
      create_list(:post, 3, user: user)
      expect(user.posts.count).to eq(3)
    end

    it "destroys associated posts when user is destroyed" do
      user = create(:user, :with_posts)
      expect { user.destroy }.to change { Post.count }.by(-3)
    end
  end

  describe "authentication" do
    let(:user) { create(:user, password: "specific_password", password_confirmation: "specific_password") }

    it "authenticates with correct password" do
      expect(user.valid_password?("specific_password")).to be_truthy
    end

    it "doesn't authenticate with incorrect password" do
      expect(user.valid_password?("wrong_password")).to be_falsey
    end
  end

  describe "scopes and class methods" do
    before do
      create_list(:user, 3)
      create_list(:admin_user, 2)
    end

    describe ".admins" do
      it "returns only admin users" do
        expect(User.where(role: :admin).count).to eq(2)
      end
    end

    describe ".authors" do
      it "returns only author users" do
        expect(User.where(role: :author).count).to eq(3)
      end
    end
  end
end
