class CreateStaticTexts < ActiveRecord::Migration
  def change
    create_table :static_texts do |t|
      t.string :title
      t.string :path
      t.string :template
      t.boolean :enable_route, :default => true
      t.text :text
      t.text :meta_keywords
      t.text :meta_description

      t.timestamps
    end
  end
end
