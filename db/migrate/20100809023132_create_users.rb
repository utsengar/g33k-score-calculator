class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :github_id
      t.string :stackoverflow_id
      t.string :email_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
