class RenameContentColumnToMesseages < ActiveRecord::Migration[5.1]
  def change
    rename_column :messages, :content, :message_content
  end
end
