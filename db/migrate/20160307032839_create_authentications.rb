class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.references :user
      t.references :credential

      t.timestamps
    end
  end
end
