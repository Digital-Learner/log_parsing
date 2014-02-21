class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.datetime :voted_at
      t.integer :campaign_id
      t.string :validity
      t.string :choice

      t.timestamps
    end
  end
end
