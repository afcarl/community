require 'factory_girl'

# For now, we'll keep all factories in this one file.
# We can refactor later into separate files by model, as necessary.

FactoryGirl.define do
  factory :contact do
    sequence  :name  do | n | "Jennifer #{n+1}" end
    sequence  :email do | n | "jennifer#{n+1}@gmail.com" end
    sex       'female'
    phone     '704-867-5309'
    birthday  '1981-04-01'.to_date
    age        nil

    sequence  :street do | n | "#{n+1} Main Street" end
    city         "Davidson"
    state        "NC"
    postal_code  "28036"

    trait :male do
      sex 'male'
    end
  end
end
