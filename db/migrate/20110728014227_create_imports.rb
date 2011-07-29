class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.integer :source_rows
      t.integer :success_rows
      t.text :import_errors
      t.timestamps
    end
  end

  def self.down
    drop_table :imports
  end
end
