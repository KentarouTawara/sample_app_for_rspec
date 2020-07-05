require 'rails_helper'

RSpec.describe Task, type: :model do
  # 正常系と異常系を意識して書くようにする
  describe 'タスクモデルのバリデーション' do
    it '一意のタイトル、ステータスがある場合、有効である' do
      # user_a = FactoryBot.create(:user)
      task = build(:task)
      expect(task).to be_valid
    end
    it 'タイトルがない場合、無効である' do
      task_without_title  = build(:task, title: "")
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to eq ["can't be blank"]
    end
    it 'タイトルが一意でない場合、無効である' do
      task1 = create(:task)
      task2 = build(:task, title: task1.title)
      expect(task2).to be_invalid
      expect(task2.errors[:title]).to eq ['has already been taken']
    end
    it 'ステータスがない場合、無効である' do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to eq ["can't be blank"]
    end
  end
end
