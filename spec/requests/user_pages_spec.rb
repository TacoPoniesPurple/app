require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Iniciar sesion') }
    it { should have_selector('title', text: 'Iniciar sesion') }
  end

  describe "signup" do

    before { visit sugnup_path }

    let(:submit) { "Crear mi cuenta" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(USer, :count)
        end
    end

    describe "with valid information" do
      before do
        fill_in "Nombre",       with: "Hazel Feathers"
        fill_in "Email",        with: "hazel@feathers.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmacion", with: "foobar"
      end

      if "should create a user" do
      expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
