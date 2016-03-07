class CreateTwitterCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :twitter_credentials do |t|
      t.string :twitter_id, index: true
      t.string :twitter_nickname
      t.string :token
      t.string :secret
      t.json :auth_hash

      t.timestamps
    end
  end
end
