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
      #before do
      #  fill_in "Email",    with: user.email.upcase
      #  fill_in "Password", with: user.password
      #  click_button "Iniciar sesion"
      #end
      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link('Usuarios', href: users_path) }
      it { should have_link('Perfil', href: user_path(user)) }
      it { should have_link('Opciones', href: edit_user_path(user)) }
      it { should have_link('Cerrar sesion', href: signout_path) }

      it { should_not have_link('Iniciar sesion', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Cerrar sesion" }
        it { should have_link('Iniciar sesion') }
      end
    end
  end


  describe "Authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Iniciar sesion"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Editar usuario')
          end
        end
      end

      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Iniciar sesion') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Iniciar sesion') }
        end
      end

      describe "as wrong user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user }

        describe "visiting Users#edit page" do
          before { visit edit_user_path(wrong_user) }
          it { should_not have_selector('title', text: full_title('Editar usuario')) }
        end

        describe "submitting a PUT request to the Users#update action" do
          before { put user_path(wrong_user) }
          specify { response.should redirect_to(root_path) }
        end
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end