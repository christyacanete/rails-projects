class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :name
        t.string :email
        t.string :password_digest
        t.string :role

        t.timestamps
      end
    end
  end
end
