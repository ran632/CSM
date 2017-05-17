class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :title
      t.text :code
      t.string :syntax
      t.integer :privacy_setting
      t.references :user, index: true

      t.timestamps
    end
  end
end
