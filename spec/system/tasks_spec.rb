require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user){ create(:user) }
  let(:task){ create(:task) }

  describe "ログイン前" do
    describe "タスク関連ページへの遷移" do
      context '新規登録ページへのアクセス' do
        it '新規登録ページへのアクセス失敗' do
          visit new_task_path
          expect(page).to have_content('Login required')
          expect(current_path).to eq login_path
        end
      end

      context '編集ページへのアクセス' do
        it '編集ページへのアクセス失敗' do
          visit edit_task_path(task)
          expect(page).to have_content('Login required')
          expect(current_path).to eq login_path
        end
      end

      context '詳細ページへのアクセス' do
        it '詳細ページへのアクセスの成功' do
          visit task_path(task)
          expect(page).to have_content(task.title)
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タスク一覧ページへのアクセス' do
        it 'タスク一覧が表示される' do
          task_list = create_list(:task, 3)
          visit tasks_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).to have_content task_list[2].title
          expect(current_path).to eq tasks_path
        end
      end
    end
  end

    describe 'ログイン後' do
      before do
        login_as(user)
      end

      describe 'タスクの新規作成' do
        context "入力が正常に作成する" do
          it 'タスクが新規作成される' do
            visit new_task_path
            fill_in 'Title', with: '新規作成'
            fill_in 'Content', with: '新規作成の内容'
            click_on 'Create Task'
            expect(current_path).to eq '/tasks/1'
            expect(page).to have_content("Task was successfully created")
            expect(page).to have_content('新規作成')
          end
        end

        context "タイトルが未入力" do
          it 'タスクの新規作成が失敗する' do
            visit new_task_path
            fill_in 'Title', with: ''
            fill_in 'Content', with: '新規作成の内容'
            click_on 'Create Task'
            expect(current_path).to eq '/tasks'
            expect(page).to have_content("Title can't be blank")
          end
        end

        context '登録済みのタイトルを入力' do
          it 'タスクの新規作成が失敗する' do
            user_a = create(:user)
            task_existed = create(:task, user: user_a)
            visit new_task_path
            fill_in 'Title', with: task_existed.title
            fill_in 'Content', with: '新規作成の内容'
            click_on 'Create Task'
            expect(current_path).to eq '/tasks'
            expect(page).to have_content("Title has already been taken")
          end
        end
      end

      describe 'タスクの編集' do
        context "フォームの入力が正常" do
          it 'タスクが編集が成功する' do
            task = create(:task, user: user)
            visit edit_task_path(task)
            fill_in 'Title', with: '変更後タイトル'
            fill_in 'Content', with: '変更後内容'
            click_on 'Update Task'
            expect(current_path).to eq task_path(task)
            expect(page).to have_content("Task was successfully updated")
            expect(page).to have_content('変更後タイトル')
          end
        end

        context 'タイトルが未入力' do
          it 'タスクの編集が失敗する' do
            task = create(:task, user: user)
            visit edit_task_path(task)
            fill_in 'Title', with: ''
            fill_in 'Content', with: '変更後内容'
            click_on 'Update Task'
            expect(current_path).to eq task_path(task)
            expect(page).to have_content("Title can't be blank")
          end
        end

        context '登録済みのタイトルを入力' do
          it 'タスクの編集に失敗する' do
            task = create(:task, user: user)
            user_a = create(:user)
            task_existed = create(:task, user: user_a)
            visit edit_task_path(task)
            fill_in 'Title', with: task_existed.title
            fill_in 'Content', with: '新規作成の内容'
            click_on 'Update Task'
            expect(current_path).to eq task_path(task)
            expect(page).to have_content("Title has already been taken")
          end
        end
      end
      
      describe 'タスクの削除' do
        it 'タスクの削除が成功する' do
          task = create(:task, user: user)
          visit tasks_path
          click_link 'Destroy'
          page.driver.browser.switch_to.alert.accept
          expect(current_path).to eq tasks_path
          expect(page).to have_no_content(task.title)
        end
      end
    end
end
