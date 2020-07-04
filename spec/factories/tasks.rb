FactoryBot.define do
  factory :task do
    title {'testを書く'}
    content {'テスト用に使用される内容です'}
    status {'todo'}
    association :user
  end
end
