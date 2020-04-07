class CreateFormularies < ActiveRecord::Migration[6.0]
  def change
    create_table :formularies do |t|
      t.string :name, unique: true

      t.timestamps
    end

    add_index :formularies, :name, unique: true
  end
end
