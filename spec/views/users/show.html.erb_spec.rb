# spec/views/users/show.html.erb_spec.rb
require 'rails_helper'

RSpec.describe 'users/show.html.erb', type: :view do
  let(:user) { build_stubbed(:user, email: 'test@example.com', role: 'admin') }

  before do
    assign(:user, user)

    allow(view).to receive_messages(current_user: user, user_signed_in?: true, edit_user_registration_path: '/en/users/edit')

    render
  end

  it 'displays the user email' do
    expect(rendered).to have_text(user.email)
  end

  it 'displays the user role' do
    expect(rendered).to have_text(user.role)
  end

  it 'has a link to edit profile' do
    expect(rendered).to have_link('Edit profile', href: '/en/users/edit')
  end
end
