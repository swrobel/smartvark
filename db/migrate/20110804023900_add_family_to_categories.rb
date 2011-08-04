class AddFamilyToCategories < ActiveRecord::Migration
  def self.up
    Category.find("entertain-me").children.create!(:name=>"Family",:parent_name=>"Entertainment")
    cat_id = Category.find_by_name("Family").id
    YipitCategory.update_all "category_id = '#{cat_id}'", "yipit_slug in ('kids','baby')"
  end

  def self.down
    cat_id = Category.find("childrens").id
    YipitCategory.update_all "category_id = '#{cat_id}'", "yipit_slug = 'kids'"
    cat_id = Category.find("baby").id
    YipitCategory.update_all "category_id = '#{cat_id}'", "yipit_slug = 'baby'"
    Category.find_by_name("Family").delete
  end
end
