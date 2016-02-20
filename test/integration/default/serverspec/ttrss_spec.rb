require "serverspec"

set :backend, :exec

#describe service("ttrssd") do
#  it { should be_enabled }
#  it { should be_running }
#end

describe port("80") do
  it { should be_listening }
end

describe command("curl -L localhost/tt-rss/install") do
  its(:stdout) { should match /Tiny Tiny RSS - Installer/ }
  its(:stdout) { should match /config.php already exists in tt-rss directory/ }
end

describe file("/opt/ttrss-plugins/auth_ldap") do
  it { should be_directory }
end

describe file("/opt/ttrss/plugins.local/auth_ldap") do
  it { should be_symlink }
end
