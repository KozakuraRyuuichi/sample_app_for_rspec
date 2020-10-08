require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    # すべての属性で有効であること
    it "is valid with all attributes" do
      expect(FactoryBot.build(:task)).to be_valid
    end

    # タイトルが存在しない場合は無効であること
    it "is invalid without title" do
      task_without_title = FactoryBot.build(:task, title: nil)
      task_without_title.valid?
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    # タイトルが重複する場合は無効であること
    it "is invalid with a duplicate title" do
      FactoryBot.create(:task, title: "title1")
      task_with_duplicated_title = FactoryBot.build(:task, title: "title1")
      task_with_duplicated_title.valid?
      expect(task_with_duplicated_title.errors[:title]).to include("has already been taken")
    end

    # ステータスが存在しない場合は無効であること
    it "is invalid without status" do
      task_without_status = FactoryBot.build(:task, status: nil)
      task_without_status.valid?
      expect(task_without_statusk.errors[:status]).to include("can't be blank")
    end

    # 別のタイトルで有効であること
    it "is valid with another title" do
      FactoryBot.create(:task)
      task_with_another_title = FactoryBot.build(:task, title: "title2")
      task_with_another_title.valid?
      expect(task_with_another_title).to be_valid
    end
  end
end
