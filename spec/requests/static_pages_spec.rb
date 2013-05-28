require 'spec_helper'

describe "Static pages" do

  #let(:base_title) { "Aplicacion muestra del tutorial de Ruby on Rails" }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    #sinonimo de
    #before(:each) { visit root_path }

    let(:heading) { 'Aplicacion muestra' }
    let(:page_title) { '' }

    #it { should have_selector('h1', text: 'Aplicacion muestra') }
    #it { should have_selector('title', :text => full_title('')) }
    #it { should_not have_selector('title', :text => '| Inicio') }
    #/nerf
    #el reemplazo es reemplazado ahora por

    it_should_behave_like "all static pages"
    it { should_not have_selector('title', :text => '| Inicio') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe "Pagina de ayuda" do
    before { visit help_path }

    let(:heading) { 'Ayuda' }
    let(:page_title) { 'Ayuda' }

    it_should_behave_like "all static pages"
  end

  describe "Pagina de acerca de" do
    before { visit about_path }

    let(:heading) { 'Acerca de nosotros' }
    let(:page_title) { 'Acerca de nosotros' }

    it_should_behave_like "all static pages"
  end

  describe "Pagina de contacto" do
    before { visit contact_path }

    let(:heading) { 'Contactanos' }
    let(:page_title) { 'Contactanos' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Acerca de"
    page.should have_selector 'title', text: full_title('Acerca de nosotros')
    click_link "Ayuda"
    page.should have_selector 'title', text: full_title('Ayuda')
    click_link "Contactanos"
    page.should have_selector 'title', text: full_title('Contactanos')
    click_link "Inicio"
    click_link "Registrarse ahora!"
    page.should have_selector 'title', text: full_title('Registrarse')
    click_link "Aplicacion muestra"
    page.should have_selector 'title', text: full_title('')
  end
end