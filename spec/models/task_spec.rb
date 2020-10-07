require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    # すべての属性で有効であること
    it "is valid with all attributes" do
      expect(FactoryBot.build(:task)).to be_valid
    end

    # タイトルが存在しない場合は無効であること
    it "is invalid without title" do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    # タイトルが重複する場合は無効であること
    it "is invalid with a duplicate title" do
      FactoryBot.create(:task, title: "title1")
      task = FactoryBot.build(:task, title: "title1")
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
    end

    # ステータスが存在しない場合は無効であること
    it "is invalid without status" do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    # 別のタイトルで有効であること
    it "is valid with another title" do
      FactoryBot.create(:task)
      task = FactoryBot.build(:task, title: "title2")
      task.valid?
      expect(task).to be_valid
    end
  end
end
