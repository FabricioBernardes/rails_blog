FactoryBot.define do
  factory :post do
    sequence(:title) { |n| Faker::Lorem.sentence(word_count: 4, supplemental: true) }
    body { Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 3) }
    association :user

    trait :with_slug do
      sequence(:slug) { |n| "custom-slug-#{n}" }
    end

    trait :draft do
      status { :draft }
      published_at { nil }
    end

    trait :published do
      status { :published }
      published_at { Faker::Time.between(from: 30.days.ago, to: Time.current) }
    end

    trait :archived do
      status { :archived }
      published_at { Faker::Time.between(from: 1.year.ago, to: 2.months.ago) }
    end
  end
end
