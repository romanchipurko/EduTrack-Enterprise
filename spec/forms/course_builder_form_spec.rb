require 'rails_helper'

RSpec.describe CourseBuilderForm, type: :model do
  describe 'validations' do
    subject(:form) { described_class.new }

    it 'is invalid without title' do
      form.valid?
      expect(form.errors[:title]).to be_present
    end

    it 'is invalid without lesson_title' do
      form.valid?
      expect(form.errors[:lesson_title]).to be_present
    end
  end

  describe '#save' do
    subject(:save_form) { form.save }

    let(:form) do
      described_class.new(
        title: 'Ruby Architecture',
        description: 'Deep dive into Rails',
        lesson_title: 'Introduction'
      )
    end

    it 'creates a LearningPath' do
      expect { save_form }.to change(LearningPath, :count).by(1)
    end

    it 'sets correct attributes on LearningPath' do
      save_form
      expect(form.learning_path.title).to eq('Ruby Architecture')
    end

    context 'when Mongo document is created' do
      before { save_form }

      let(:mongo_lesson) do
        CourseContent.find_by(learning_path_id: form.learning_path.id.to_s)
      end

      it 'creates a CourseContent document in Mongo with title' do
        expect(mongo_lesson.title).to eq('Introduction')
      end
    end
  end
end
