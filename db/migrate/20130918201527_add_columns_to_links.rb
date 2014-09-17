class AddColumnsToLinks < ActiveRecord::Migration
  def change
    add_column :links, :title, :text
    add_column :links, :body, :text
  end
end
