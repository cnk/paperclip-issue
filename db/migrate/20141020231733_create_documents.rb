class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.attachment :file
      t.integer :document_category_id

      t.timestamps
    end
  end
end
