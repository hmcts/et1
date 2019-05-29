class AddUploadedFileDetailsToClaims < ActiveRecord::Migration[5.2]
  def change
    add_column :claims, :uploaded_file_key, :string
    add_column :claims, :uploaded_file_name, :string
  end
end
