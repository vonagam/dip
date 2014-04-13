class CreateGameBasis < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.text :description

      t.integer :status
      t.index :status

      t.references :creator
      t.index :creator_id

      t.timestamps
    end

    create_table :sides do |t|
      t.string :name
      t.boolean :defeated, default: false, null: false

      t.references :game
      t.index :game_id

      t.references :user
      t.index :user_id
    end

    create_table :states do |t|
      t.text :data
      t.float :date
      t.string :type

      t.references :game
      t.index :game_id
    end

    create_table :orders do |t|
      t.text :data

      t.references :side
      t.index :side_id

      t.references :state
      t.index :state_id
    end
  end
end
