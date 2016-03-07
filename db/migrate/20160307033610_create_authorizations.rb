class CreateAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :authorizations do |t|
      t.references :user
      t.references :credential

      t.timestamps
    end
  end
end
