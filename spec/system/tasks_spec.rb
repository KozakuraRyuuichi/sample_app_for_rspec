require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'タスク一覧にアクセス' do
        it 'タスク一覧が表示される'  do
          tasks = create_list(:task, 3)
          visit tasks_path
          expect(page).to have_content tasks[0].title
          expect(page).to have_content tasks[1].title
          expect(page).to have_content tasks[2].title
          expect(current_path).to eq tasks_path
        end
      end
      context 'タスク詳細にアクセス' do
        it 'タスクの詳細が表示される' do
          visit task_path(task.id)
          expect(page).to have_content(task.title)
          expect(page).to have_content(task.content)
        end
      end
      context 'タスクの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスに失敗する' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content('Login required')
        end
      end
      context 'タスクの編集ページにアクセス' do
        it '編集ページへのアクセスに失敗する' do
          visit edit_task_path(task.id)
          expect(current_path).to eq login_path
          expect(page).to have_content('Login required')
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }

    describe 'タスク作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'test_title'
          fill_in 'Content', with: 'test_content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Create Task'
          expect(page).to have_content 'Title: test_title'
          expect(page).to have_content 'Content: test_content'
          expect(page).to have_content 'Status: doing'
          expect(page).to have_content 'Deadline: 2020/6/1 10:30'
          expect(current_path).to eq '/tasks/1'
        end
      end
      context 'タイトルが未入力' do
        it 'タスク作成に失敗する' do
          click_on 'New Task'
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
          expect(page).to have_content("Title can't be blank")
        end
      end
      context 'タイトルが重複' do
        it 'タスク作成に失敗する' do
          click_on 'New Task'
          fill_in 'Title', with: task.title
          fill_in 'Content', with: 'content'
          select 'todo', from: 'Status'
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
          expect(page).to have_content("Title has already been taken")
        end
      end
    end

    describe 'タスク編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      before { visit edit_task_path(task) }

      context 'フォームの入力値が正常' do
        it 'タスク編集に成功する' do
          # visit edit_task_path(task.id)
          click_on 'Edit'
          fill_in 'Title', with: task.title
          fill_in 'Content', with: 'update_content'
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(user.id)
          expect(page).to have_content("Task was successfully updated.")
        end
      end
      context 'タイトルが未入力' do
        it 'タスク作成に失敗するる' do
          visit login_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          click_button 'Login'
          click_on 'Edit'
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'update_content'
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(user.id)
          expect(page).to have_content("Title can't be blank")
        end
      end
      context 'タイトルが重複' do
        it 'タスク作成に失敗するる' do
          visit login_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          click_button 'Login'
          click_on 'Edit'
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'update_content'
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(current_path).to eq task_path(user.id)
          expect(page).to have_content("Title has already been taken")
        end
      end
    end

    describe 'タスク削除' do
      let!(:task) {create(:task, user: user)}
      context '自分のタスク' do
        it '削除できること' do
          visit login_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          click_button 'Login'
          click_on 'Destroy'
          page.driver.browser.switch_to.alert.accept
          expect(current_path).to eq tasks_path
          expect(page).to have_content('Task was successfully destroyed.')
        end
      end
    end
  end
end