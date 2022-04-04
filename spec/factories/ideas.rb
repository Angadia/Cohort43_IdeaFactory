FactoryBot.define do
  factory :idea do
    title { Faker::Quote.yoda }
    description { Faker::GreekPhilosophers.quote}
  end
end
