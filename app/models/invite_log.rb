class InviteLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :invite
end
