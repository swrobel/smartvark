class RenameLogoNameToLogoFileNameForUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :logo_name, :logo_file_name
    rename_column :users, :logo_size, :logo_file_size
    add_column    :users, :logo_content_type, :string
    add_column    :users, :logo_updated_at, :datetime
  end

  def self.down
    rename_column :users, :logo_file_name, :logo_name
    rename_column :users, :logo_file_size, :logo_size
    remove_column    :users, :logo_content_type
    remove_column    :users, :logo_updated_at
  end
end
