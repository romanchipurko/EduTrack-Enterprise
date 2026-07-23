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
  end

  describe 'relations' do
    let(:relation) { described_class.relations['elements'] }

    it 'embeds many elements' do
      expect(relation.relation).to eq(Mongoid::Association::Embedded::EmbedsMany::Proxy)
    end

    it 'uses Elements::Base as class_name' do
      expect(relation.class_name).to eq('Elements::Base')
    end
  end

  describe 'indexes' do
    let(:index_specifications) { described_class.index_specifications }
    let(:compound_index) do
      index_specifications.find { |s| s.key == { learning_path_id: 1, position: 1 } }
    end

    it 'has an index on learning_path_id' do
      has_index = index_specifications.any? { |spec| spec.key == { learning_path_id: 1 } }
      expect(has_index).to be true
    end

    it 'has a compound index on learning_path_id and position' do
      expect(compound_index).to be_present
    end

    it 'sets compound index as unique' do
      expect(compound_index.options[:unique]).to be true
    end
  end

  describe 'validations and behavior' do
    it 'is valid with valid attributes' do
      expect(build(:course_content)).to be_valid
    end

    it 'is valid with code block trait' do
      expect(build(:course_content, :with_code_block)).to be_valid
    end

    it 'is valid with empty elements trait' do
      expect(build(:course_content, :empty_elements)).to be_valid
    end

    it 'is invalid without a title' do
      expect(build(:course_content, title: nil)).not_to be_valid
    end

    it 'is invalid without a learning_path_id' do
      expect(build(:course_content, learning_path_id: nil)).not_to be_valid
    end

    it 'is invalid with a negative position' do
      course = build(:course_content, position: -1)
      course.valid?
      expect(course.errors[:position]).to include('must be greater than or equal to 0')
    end
  end
end
