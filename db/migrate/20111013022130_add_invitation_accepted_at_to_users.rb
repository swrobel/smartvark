class AddInvitationAcceptedAtToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.datetime :invitation_accepted_at
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :invitation_accepted_at
    end
  end
end
