FactoryBot.define do
  factory :task do
    sequence(:title,'test_1')
    content { 'テスト用に使用される内容です' }
    status { :todo }
    deadline { 1.week.from_now }
    association :user
  end
end
