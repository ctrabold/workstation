#
# Wrapper tasks for ansible
#

namespace :ansible do
  namespace :create do
    desc "Create a new role"
    task :role, :name do |t, args|
      set_role_template(args.name)
    end
  end

  desc "Test roles with syntax-check"
  task :syntax_check do
    sh "ansible-playbook --syntax-check -i hosts.ini playbook.yml"
  end
end
