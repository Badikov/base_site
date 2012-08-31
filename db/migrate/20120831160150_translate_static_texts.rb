class TranslateStaticTexts < ActiveRecord::Migration
  def self.up
    StaticText.create_translation_table!({
      :title => :string,
      :text => :text,
      :meta_description => :text, 
      :meta_keywords => :text
    }, {
      :migrate_data => true
    })
  end

  def self.down
    StaticText.drop_translation_table! :migrate_data => true
  end
end
