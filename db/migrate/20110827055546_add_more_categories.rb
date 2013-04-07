class AddMoreCategories < ActiveRecord::Migration
  def self.up
    entertain = Category.find("entertain-me")
    entertain.children.create(name: "Classes")
    entertain.children.create(name: "Comedy")
    entertain.children.create(name: "Concerts")
    entertain.children.create(name: "Dancing")
    entertain.children.create(name: "Theater")
    entertain.children.create(name: "Travel")
    
    revitalize = Category.find("revitalize-me")
    revitalize.children.create(name: "Gyms")
    revitalize.children.create(name: "Pilates")
    
    serve = Category.find("serve-me")
    serve.children.create(name: "Photography")
  end

  def self.down
    Category.find("comedy").delete!
    Category.find("concerts").delete!
    Category.find("dancing").delete!
    Category.find("theater").delete!
    Category.find("classes").delete!
    Category.find("gyms").delete!
    Category.find("pilates").delete!
    Category.find("photography").delete!
    Category.find("travel").delete!
  end
end
