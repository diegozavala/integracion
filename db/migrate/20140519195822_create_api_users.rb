class CreateApiUsers < ActiveRecord::Migration
  def change
    create_table :api_users do |t|
      t.string :name
      t.string :password

      t.timestamps
    end
  end
end
