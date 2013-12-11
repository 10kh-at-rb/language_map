FactoryGirl.define do
  factory :repository do
    sequence(:url) {|n| "https://github.com/user#{n}/repo#{n}" }
    language "Ruby"
    location "Washington, DC"
  end
end
