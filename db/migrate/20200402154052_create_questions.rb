class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :name
      t.integer :question_type, default: 0
      t.string :content
      t.references :formulary, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :questions, :name, unique: true
  end
end
