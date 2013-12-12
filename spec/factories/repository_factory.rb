FactoryGirl.define do
  factory :repository do
    sequence(:sha) { |n| "acbde#{n}" }
    sequence(:url) { |n| "https://github.com/user#{n}/repo#{n}" }
    language "Ruby"
    location "Washington, DC"
  end
end
