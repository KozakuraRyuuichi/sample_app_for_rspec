require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規登録が成功する' do
          visit new_user_path
          fill_in 'Email', with: 'email@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(current_path).to eq login_path
          expect(page).to have_content('User was successfully created.')
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規登録に失敗する' do
          visit new_user_path
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content("Email can't be blank")
          expect(current_path).to eq users_path
        end
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの新規登録に失敗する' do
          existed_user = create(:user)
          visit new_user_path
          fill_in 'Email', with: existed_user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content("Email has already been taken")
          expect(current_path).to eq users_path
          expect(page).to have_field 'Email', with: existed_user.email
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit users_path
          expect(page).to have_content('Login required')
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_path(user)
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'update_password'
          fill_in 'Password confirmation', with: 'update_password'
          click_button 'Update'
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content("User was successfully updated.")
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'new_password'
          fill_in 'Password confirmation', with: 'new_password'
          click_button 'Update'
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content("Email can't be blank")
          expect(current_path).to eq user_path(user.id)
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          another_user = create(:user,
                                email: 'email@example.com',
                                password: 'another_password',
                                password_confirmation: 'another_password')
          click_on 'Mypage'
          click_on 'Edit'
          fill_in 'Email', with: another_user.email
          fill_in 'Password', with: 'new_password'
          fill_in 'Password confirmation', with: 'new_password'
          click_button 'Update'
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content("Email has already been taken")
          expect(current_path).to eq user_path(user.id)
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          another_user = create(:user,
                                email: 'email@example.com',
                                password: 'another_password',
                                password_confirmation: 'another_password')
          click_on 'Mypage'
          visit edit_user_path(another_user.id)
          expect(page).to have_content("Forbidden access.")
          expect(current_path).to eq user_path(user.id)
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          visit user_path(user)
          click_on 'New task'
          create(:task, title: 'test_title', status: :todo, user: user)
          visit user_path(user)
          expect(page).to have_content("test_title")
          expect(page).to have_content("todo")
        end
      end
    end
  end
end