class AddGithubExcludedAccountsToRoles < ActiveRecord::Migration[7.1]
  def change
    add_column :roles, :github_excluded_accounts, :text, array: true, default: []
  end
end
