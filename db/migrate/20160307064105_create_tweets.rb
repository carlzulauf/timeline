class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.references :credential
      t.string :tweet_id, index: true
      t.json :info

      t.timestamps
    end

    add_column :twitter_credentials, :last_tweet_id, :string
  end
end
