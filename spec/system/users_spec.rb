require 'rails_helper'

RSpec.describe "Users", type: :system do
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
        before do
          @user = create(:user)
        end
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: @user.email
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
        before do
          @user = create(:user)
        end
        it 'マイページへのアクセスが失敗する' do
          visit user_path(@user)
          expect(current_path).to eq '/login'
          expect(page).to have_content('Login required')
        end
      end
    end
  end
  describe 'ログイン後' do
    before do
      @user = create(:user)
      @user_a = create(:user)
      @user_b = create(:user)
      visit login_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'password'
      click_button 'Login'
    end
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit user_path(@user)
          expect(current_path).to eq user_path(@user)
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: 'updated@example.com'
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(current_path).to eq user_path(@user)
          expect(page).to have_content('User was successfully updated')
          expect(page).to have_content('updated@example.com')
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit user_path(@user)
          expect(current_path).to eq user_path(@user)
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: ''
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(current_path).to eq user_path(@user)
          expect(page).to have_content("Email can't be blank")
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit user_path(@user_a)
          expect(current_path).to eq user_path(@user_a)
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: @user_b.email
          fill_in 'Password', with: '87654321'
          fill_in 'Password confirmation', with: '87654321'
          click_on 'Update'
          sleep 1
          expect(page).to have_content("Email has already been taken")
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit user_path(@user_a)
          expect(current_path).to eq user_path(@user_a)
          visit edit_user_path(@user_b)
          expect(page).to have_no_content(@user_b.email)
        end
      end
    end
    describe 'マイページ' do
      context 'タスクを作成' do
        before do
          @task = build(:task)
        end
        it '新規作成したタスクが表示される' do
          visit new_task_path
          expect(current_path).to eq new_task_path
          fill_in 'Title', with: @task.title
          fill_in 'Content', with: @task.content
          click_on 'Create Task'
          expect(page).to have_content("Task was successfully created")
          expect(page).to have_content @task.title
        end
      end
    end
  end
end
