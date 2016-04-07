class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :to_user_type, default: Message::TO_USER_TYPE_NORMAL
      t.string :content, null: :false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
