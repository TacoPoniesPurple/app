require 'spec_helper'

describe "Static pages" do

  #let(:base_title) { "Aplicacion muestra del tutorial de Ruby on Rails" }

  subject { page }

  describe "Pagina de inicio" do
    before { visit root_path }
    #sinonimo de
    #before(:each) { visit root_path }

    it { should have_selector('h1', text: 'Aplicacion muestra') }
    it { should have_selector('title', :text => full_title('')) }
    it { should_not have_selector('title', :text => '| Inicio') }
    #/nerf
  end

  describe "Pagina de ayuda" do
    before { visit help_path }

    it { should have_selector('h1', :text => 'Ayuda') }
    it { should have_selector('title', :text => full_title('Ayuda')) }
  end

  describe "Pagina de acerca de" do
    before { visit about_path }

    it { should have_selector('h1',:text => 'Acerca de nosotros') }
    it { should have_selector('title', :text => full_title('Acerca de nosotros')) }
  end

  describe "Pagina de contacto" do
    before { visit contact_path }

    it { should have_selector('h1',:text => 'Contactanos') }
    it { should have_selector('title', :text => full_title('Contactanos')) }
  end
end