class ChangePostsToUtf8mb4 < ActiveRecord::Migration[5.0]
  def change
    execute "ALTER TABLE posts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE posts MODIFY content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
end
