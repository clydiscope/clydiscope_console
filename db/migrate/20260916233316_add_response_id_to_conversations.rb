class AddResponseIdToConversations < ActiveRecord::Migration[8.1]
  def change
    add_column :conversations, :response_id, :string
  end
end
