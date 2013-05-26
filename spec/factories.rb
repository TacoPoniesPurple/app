FactoryGirl.define do
  factory :user do
    name     "Hazel Feathers"
    email    "hazel@feathers.com"
    password "foobar"
    password_confirmation "foobar"
  end
end