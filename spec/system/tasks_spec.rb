require 'rails_helper'

RSpec.describe "Tasks", type: :system do

  describe "ログイン前" do
    describe "タスク関連ページへの遷移" do
      context '新規登録ページへのアクセス' do
        it '新規登録ページへのアクセス失敗'

      end
      context '編集ページへのアクセス' do
        it '編集ページへのアクセス失敗'

      end
      context '詳細ページへのアクセス' do
        it '詳細ページへのアクセスの失敗'

      end
      context 'タスク一覧ページへのアクセス' do
        it 'タスク一覧が表示される'

      end
    end
  end

    describe 'ログイン後' do
      describe 'タスクの新規作成' do
        context "入力が正常に作成する" do
          it 'タスクが新規作成される'

        end
        context "タイトルが未入力" do
          it 'タスクの新規作成が失敗する'
        end
        context '登録済みのタイトルを入力' do
          it 'タスクの新規作成が失敗する'

        end
      end
      
      describe 'タスクの編集' do
        context "フォームの入力が正常" do
          it 'タスクが編集が成功する'
          
        end

        context 'タイトルが未入力' do
          it 'タスクの編集が失敗する'

        end
        context '登録済みのタイトルを入力' do
          it 'タスクの編集に失敗する'

        end

      end
      
      describe 'タスクの削除' do
        it 'タスクの削除が成功する'
          
      end
    end
end
