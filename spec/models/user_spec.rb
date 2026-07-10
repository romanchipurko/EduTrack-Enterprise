require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "validations" do
    it { expect(user).to validate_presence_of(:email) }

    it do
      create(:user)

      expect(user).to validate_uniqueness_of(:email).case_insensitive
    end
  end

  describe "enums" do
    it do
      expect(user).to define_enum_for(:role).with_values(
        student: 0,
        instructor: 1,
        admin: 2
      )
    end
  end

  describe "factory" do
    it { expect(build(:user)).to be_valid }
  end

  describe "roles" do
    it { expect(build(:user, role: :student)).to be_student }
    it { expect(build(:user, role: :instructor)).to be_instructor }
    it { expect(build(:user, role: :admin)).to be_admin }
  end

  describe "password validations" do
    subject(:password_errors) do
      user.validate
      user.errors[:password]
    end

    context "with valid password" do
      let(:user) do
        build(
          :user,
          password: "Password123",
          password_confirmation: "Password123"
        )
      end

      it { expect(user).to be_valid }
    end

    context "without uppercase letter" do
      let(:user) do
        build(
          :user,
          password: "password123",
          password_confirmation: "password123"
        )
      end

      it { expect(password_errors).to be_present }
    end

    context "without lowercase letter" do
      let(:user) do
        build(
          :user,
          password: "PASSWORD123",
          password_confirmation: "PASSWORD123"
        )
      end

      it { expect(password_errors).to be_present }
    end

    context "without digit" do
      let(:user) do
        build(
          :user,
          password: "Password",
          password_confirmation: "Password"
        )
      end

      it { expect(password_errors).to be_present }
    end

    context "with shorter than 8 characters" do
      let(:user) do
        build(
          :user,
          password: "Pass12",
          password_confirmation: "Pass12"
        )
      end

      it { expect(password_errors).to be_present }
    end
  end
end
