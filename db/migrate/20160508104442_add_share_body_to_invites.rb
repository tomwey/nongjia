class AddShareBodyToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :share_body, :string
  end
end
