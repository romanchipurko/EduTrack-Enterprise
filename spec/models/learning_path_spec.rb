require 'rails_helper'

RSpec.describe LearningPath, type: :model do
  subject(:learning_path) { build(:learning_path) }

  describe "validations" do
    it { expect(learning_path).to validate_presence_of(:title) }
    it { expect(learning_path).to validate_presence_of(:description) }

    it do
      expect(learning_path).to validate_length_of(:title)
        .is_at_least(5)
        .is_at_most(50)
    end

    it do
      expect(learning_path).to validate_length_of(:description).is_at_most(500)
    end

    it do
      expect(learning_path).to allow_value("Ruby on Rails 8").for(:title)
    end

    it do
      expect(learning_path).not_to allow_value("Ruby@Rails!").for(:title)
    end
  end

  describe "factory" do
    it { expect(build(:learning_path)).to be_valid }
  end
end
