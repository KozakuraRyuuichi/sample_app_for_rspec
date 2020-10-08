require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    # すべての属性で有効であること
    it "is valid with all attributes" do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    # タイトルが存在しない場合は無効であること
    it "is invalid without title" do
      task_without_title = build(:task, title: nil)
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    # タイトルが重複する場合は無効であること
    it "is invalid with a duplicate title" do
      task = create(:task)
      task_with_duplicated_title = build(:task, title: task.title)
      expect(task_with_duplicated_title).to be_invalid
      expect(task_with_duplicated_title.errors[:title]).to include("has already been taken")
    end

    # ステータスが存在しない場合は無効であること
    it "is invalid without status" do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end

    # 別のタイトルで有効であること
    it "is valid with another title" do
      task = create(:task)
      task_with_another_title = build(:task, title: "title2")
      expect(task_with_another_title).to be_valid
      expect(task_with_another_title.errors).to be_empty
    end
  end
end
