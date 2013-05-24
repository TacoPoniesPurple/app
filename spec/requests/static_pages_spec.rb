require 'spec_helper'

describe "Static pages" do
  describe "Pagina de inicio" do

    it "should have the h1 'Aplicacion muestra'" do
      visit '/static_pages/home'
      page.should have_selector('h1',:text => "Aplicacion muestra")
    end

    it "should have the title 'Aplicacion muestra'" do
      visit '/static_pages/home'
      page.should have_selector('title',
                  :text => "Aplicacion muestra del tutorial de Ruby on Rails | Inicio")
    end
  end

  describe "Pagina de ayuda" do

    it "should have the h1 'Ayuda'" do
      visit '/static_pages/help'
      page.should have_selector('h1',:text => 'Ayuda')
    end

    it "should have the title 'Ayuda'" do
      visit '/static_pages/help'
      page.should have_selector('title',
                  :text => 'Aplicacion muestra del tutorial de Ruby on Rails | Ayuda')
    end

  end

  describe "Pagina de acerca de" do

    it "should have the h1 'Acerca de nosotros'" do
      visit '/static_pages/about'
      page.should have_selector('h1',:text => 'Acerca de nosotros')
    end

    it "should have the title 'Acerca de nosotros'" do
      visit '/static_pages/about'
      page.should have_selector('title',
                  :text => 'Aplicacion muestra del tutorial de Ruby on Rails | Acerca de nosotros')
    end

  end


end