require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Iniciar sesion" }

      it { should have_selector('title', text: 'Iniciar sesion') }
      it { should have_selector('div.alert.alert-error', text: 'incorrecta') }

      describe "after visiting another page" do
        before { click_link "Inicio" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Iniciar sesion"
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Perfil', href: user_path(user)) }
      it { should have_link('Cerrar sesion', href: signout_path) }
      it { should_not have_link('Iniciar sesion', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Cerrar sesion" }
        it { should have_link('Iniciar sesion') }
      end
    end
  end
end
