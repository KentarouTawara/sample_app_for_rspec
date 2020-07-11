require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user){ create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit sign_up_path
          fill_in 'user_email', with: 'a@example.com'
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
          fill_in 'user_email', with: ''
          fill_in 'Password', with: "12345678"
          fill_in 'Password confirmation', with: "12345678"
          click_button 'SignUp'
          expect(current_path).to eq '/users'
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
          expect(current_path).to eq '/users'
          expect(page).to have_content("Email has already been taken")
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
    let(:user_a){ create(:user) }
    let(:user_b){ create(:user) }
    let(:task_a){ create(:task, user: user_a) }

    before do
      login_as(user_a)
    end

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit user_path(user_a)
          expect(current_path).to eq user_path(user_a)
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: 'updated@example.com'
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(current_path).to eq user_path(user_a)
          expect(page).to have_content('User was successfully updated')
          expect(page).to have_content('updated@example.com')
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit user_path(user_a)
          expect(current_path).to eq user_path(user_a)
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: ''
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(current_path).to eq user_path(user_a)
          expect(page).to have_content("Email can't be blank")
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit user_path(user_a)
          expect(current_path).to eq user_path(user_a)
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: user_b.email
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(current_path).to eq user_path(user_a)
          expect(page).to have_content("Email has already been taken")
        end
      end

      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit user_path(user_a)
          expect(current_path).to eq user_path(user_a)
          visit edit_user_path(user_b)
          expect(current_path).to eq user_path(user_a)
          expect(page).to have_no_content(user_b.email)
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          visit new_task_path
          fill_in 'Title', with: '最初のタスク'
          fill_in 'Content', with: '最初のタスクの中身'
          click_on 'Create Task'
          expect(current_path).to eq '/tasks/2'
          expect(page).to have_content("Task was successfully created")
          expect(page).to have_content('最初のタスク')
        end
      end
    end
  end
end
