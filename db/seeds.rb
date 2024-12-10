# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Create SCIM users
if Rails.env.development? || Rails.env.test?
	scim_users_data = [
		{
			username: 'john.doe',
			scim_uid: 'emp123',
			is_active: true,
			work_email_address: 'john.doe@example.com',
			displayname: 'John Doe',
			first_name: 'John',
			last_name: 'Doe'
		},
		{
			username: 'jane.smith',
			scim_uid: 'emp124',
			is_active: true,
			work_email_address: 'jane.smith@example.com',
			displayname: 'Jane Smith',
			first_name: 'Jane',
			last_name: 'Smith'
		}
	]

	scim_users_data.each do |user_data|
		User.find_or_create_by!(scim_uid: user_data[:scim_uid]) do |user|
			user.assign_attributes(user_data)
		end
	end

	# Create SCIM roles
	roles_data = [
		{
			name: 'Admin',
			scim_uid: 'role_admin',
			is_active: true,
		},
		{
			name: 'User',
			scim_uid: 'role_user',
			is_active: true
		}
	]

	roles_data.each do |role_data|
		Role.find_or_create_by!(scim_uid: role_data[:scim_uid]) do |role|
			role.assign_attributes(role_data)
		end
	end

	# Assign Admin role to John Doe
	john = User.find_by(username: 'john.doe')
	admin_role = Role.find_by(	name: 'Admin')
	
	if john && admin_role && !john.roles.include?(admin_role)
		john.roles << admin_role
	end

	puts "Created #{User.count} SCIM users"
	puts "Created #{Role.count} SCIM roles"
	puts "Assigned Admin role to #{john.displayname}"
end