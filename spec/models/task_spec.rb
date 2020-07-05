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
      task_without_title  = build(:task, title: nil)
      task_without_title.valid?
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end
    it 'タイトルが一意でない場合、無効である' do
      task1 = create(:task)
      task2 = build(:task, title: task1.title)
      task2.valid?
      expect(task2.errors[:title]).to include('has already been taken')
    end
    it 'ステータスがない場合、無効である' do
      task_without_status = build(:task, status: nil)
      task_without_status.valid?
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end
  end
end
