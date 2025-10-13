FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 10, max_length: 20, mix_case: true, special_characters: true) }
    password_confirmation { password }
    role { :author }

    trait :admin do
      role { :admin }
    end

    trait :with_posts do
      transient do
        posts_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end
    end

    trait :with_published_posts do
      after(:create) do |user, evaluator|
        create_list(:post, 2, :published, user: user)
      end
    end

    trait :with_uppercase_email do
      email { Faker::Internet.unique.email.upcase }
    end

    factory :admin_user do
      role { :admin }
    end
  end
end
