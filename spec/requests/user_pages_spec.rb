require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'Todos los usuarios') }
    it { should have_selector('h1', text: 'Todos los usuarios') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('borrar') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('borrar', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('borrar') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('borrar', href: user_path(admin)) }
      end
    end

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }

    #it { should have_content(user.name) }
    #it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Seguir"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Seguir"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Seguir" }
          it { should have_selector('input', value: 'Dejar de seguir') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Dejar de seguir"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Dejar de seguir"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Dejar de seguir" }
          it { should have_selector('input', value: 'Seguir') }
        end

      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Registrarse') }
    it { should have_selector('title', text: 'Registrarse') }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Crear mi cuenta" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', content: 'Registro') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Nombre",       with: "Hazel Feathers"
        fill_in "Email",        with: "hazel@feathers.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmacion", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('hazel@feathers.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Bienvenido') }
        it { should have_link('Cerrar sesion') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Actualiza tu perfil") }
      it { should have_selector('title', text: "Editar usuario") }
      it { should have_link('cambiar', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Guardar cambios" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "Nuevo Nombre" }
      let(:new_email) { "nuevo@ejemplo.com" }
      before do
        fill_in "Nombre",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirmar Password", with: user.password
        click_button "Guardar cambios"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Cerrar sesion', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector('title', text: full_title('Siguiendo')) }
      it { should have_selector('h3', text: 'Siguiendo') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector('title', text: full_title('Seguidores')) }
      it { should have_selector('h3', text: 'Seguidores') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
  end

