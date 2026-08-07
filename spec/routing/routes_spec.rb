require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  describe 'Root and Home' do
    it 'routes GET / to home#index' do
      expect(get: '/').to route_to(controller: 'home', action: 'index')
    end

    it 'routes GET /en to home#index with locale' do
      expect(get: '/en').to route_to(controller: 'home', action: 'index', locale: 'en')
    end
  end

  describe 'Users' do
    it 'routes GET /en/profile to users#show' do
      expect(get: '/en/profile').to route_to(controller: 'users', action: 'show', locale: 'en')
    end
  end

  describe 'Learning Paths' do
    it 'routes GET /en/learning_paths to learning_paths#index' do
      expect(get: '/en/learning_paths').to route_to(controller: 'learning_paths', action: 'index', locale: 'en')
    end

    it 'routes POST /en/learning_paths/:id/enrollments to enrollments#create' do
      expect(post: '/en/learning_paths/1/enrollments').to route_to(
                                                            controller: 'enrollments', action: 'create', learning_path_id: '1', locale: 'en'
                                                          )
    end
  end

  describe 'Course Contents (Shallow nesting)' do
    it 'routes POST /en/learning_paths/:learning_path_id/course_contents to course_contents#create' do
      expect(post: '/en/learning_paths/1/course_contents').to route_to(
                                                                controller: 'course_contents', action: 'create', learning_path_id: '1', locale: 'en'
                                                              )
    end

    it 'routes GET /en/course_contents/:id/edit directly via shallow path' do
      expect(get: '/en/course_contents/2/edit').to route_to(
                                                     controller: 'course_contents', action: 'edit', id: '2', locale: 'en'
                                                   )
    end
  end

  describe 'Quizzes' do
    it 'routes POST /en/course_contents/:course_content_id/quizzes/:id/submit to quizzes#submit' do
      # Исправлено на полный путь, так как quizzes имеют shallow: false
      expect(post: '/en/course_contents/1/quizzes/5/submit').to route_to(
                                                                  controller: 'quizzes', action: 'submit', course_content_id: '1', id: '5', locale: 'en'
                                                                )
    end
  end
end
