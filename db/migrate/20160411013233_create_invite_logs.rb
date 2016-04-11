class CreateInviteLogs < ActiveRecord::Migration
  def change
    create_table :invite_logs do |t|
      t.references :user, index: true, foreign_key: true
      t.references :invite, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
