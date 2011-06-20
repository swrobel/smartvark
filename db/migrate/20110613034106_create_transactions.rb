class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.text :params
      t.string :status
      t.string :transaction_id
      t.integer :user_id
      t.integer :credits

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
