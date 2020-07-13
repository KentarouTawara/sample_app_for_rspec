require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user){ create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit sign_up_path
          fill_in 'Email', with: 'a@example.com'
          fill_in 'Password', with: "12345678"
          fill_in 'Password confirmation', with: "12345678"
          click_button 'SignUp'
          expect(current_path).to eq login_path
          expect(page).to have_content('User was successfully created')
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: ''
          fill_in 'Password', with: "12345678"
          fill_in 'Password confirmation', with: "12345678"
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content('1 error prohibited this user from being saved')
          expect(page).to have_content("Email can't be blank")
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: "12345678"
          fill_in 'Password confirmation', with: "12345678"
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content('1 error prohibited this user from being saved')
          expect(page).to have_content("Email has already been taken")
          expect(page).to have_no_content user.email
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(current_path).to eq login_path
          expect(page).to have_content('Login required')
        end
      end
    end
  end

  describe 'ログイン後' do
    # データの役割がわかる変数名を定義する
    let(:user){ create(:user) }
    let(:another_user){ create(:user) }
    let(:task){ create(:task, user: user) }

    before { login_as(user) }

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit user_path(user)
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: 'updated@example.com'
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(current_path).to eq user_path(user)
          expect(page).to have_content('User was successfully updated')
          expect(page).to have_content('updated@example.com')
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: ''
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(current_path).to eq user_path(user)
          expect(page).to have_content('1 error prohibited this user from being saved')
          expect(page).to have_content("Email can't be blank")
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit user_path(user)
          expect(current_path).to eq user_path(user)
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: another_user.email
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(current_path).to eq user_path(user)
          expect(page).to have_content("Email has already been taken")
        end
      end

      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_user_path(another_user)
          expect(current_path).to eq user_path(user)
          expect(page).to have_no_content(another_user.email)
          expect(page).to have_content('Forbidden access.')
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          visit new_task_path
          fill_in 'Title', with: '最初のタスク'
          fill_in 'Content', with: '最初のタスクの中身'
          select :doing, from: 'Status'
          click_on 'Create Task'

          visit user_path(user)
          expect(page).to have_content('最初のタスク')
          expect(page).to have_content('doing')
          expect(page).to have_link('Show')
          expect(page).to have_link('Edit')
          expect(page).to have_link('Destroy')
        end
      end
    end
  end
end
