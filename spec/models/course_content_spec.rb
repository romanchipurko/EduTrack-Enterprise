require 'rails_helper'

RSpec.describe CourseContent, type: :model do
  describe 'Mongoid document structure' do
    it 'includes Mongoid::Document' do
      expect(described_class.included_modules).to include(Mongoid::Document)
    end

    it 'includes Mongoid::Timestamps' do
      expect(described_class.included_modules).to include(Mongoid::Timestamps)
    end
  end

  describe 'fields' do
    it 'defines learning_path_id field' do
      expect(described_class.fields.keys).to include('learning_path_id')
    end

    it 'types learning_path_id as String' do
      expect(described_class.fields['learning_path_id'].type).to eq(String)
    end

    it 'defines title field' do
      expect(described_class.fields.keys).to include('title')
    end

    it 'types title as String' do
      expect(described_class.fields['title'].type).to eq(String)
    end

    it 'defines position field' do
      expect(described_class.fields.keys).to include('position')
    end

    it 'types position as Integer' do
      expect(described_class.fields['position'].type).to eq(Integer)
    end

    it 'defines elements field' do
      expect(described_class.fields.keys).to include('elements')
    end

    it 'types elements as Array' do
      expect(described_class.fields['elements'].type).to eq(Array)
    end

    it 'defaults elements to an empty array' do
      expect(described_class.new.elements).to eq([])
    end
  end

  describe 'indexes' do
    let(:index_specifications) { described_class.index_specifications }

    it 'has an index on learning_path_id' do
      has_index = index_specifications.any? do |spec|
        spec.key == { learning_path_id: 1 }
      end
      expect(has_index).to be true
    end

    it 'has a compound index on learning_path_id and position' do
      has_index = index_specifications.any? do |spec|
        spec.key == { learning_path_id: 1, position: 1 }
      end
      expect(has_index).to be true
    end
  end

  describe 'validations and behavior' do
    it 'is valid with valid attributes' do
      course = build(:course_content)
      expect(course).to be_valid
    end

    it 'is valid with code block trait' do
      course = build(:course_content, :with_code_block)
      expect(course).to be_valid
    end

    it 'is valid with empty elements trait' do
      course = build(:course_content, :empty_elements)
      expect(course).to be_valid
    end
  end
end
