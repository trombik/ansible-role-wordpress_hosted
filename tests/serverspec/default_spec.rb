require "spec_helper"
require "serverspec"

user = "vagrant"
group = "vagrant"
home = "/home/#{user}"
document_root = "#{home}/web"
app_root = "#{document_root}"
plugin_dir = "#{app_root}/wp-content/plugins"
config  = "#{app_root}/wp-config.php"
salts_file = "#{app_root}/wp-salts.php"

plugins = [
  { name: "code-snippets" },
  { name: "dark-mode", version: "3.0.1" }
]
distfile_dir = "#{home}"

describe file(config) do
  it { should exist }
  it { should be_file }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 440 }
  its(:content) { should match(/^\/\/ Managed by ansible/) }
  its(:content) { should match(/^define\(\s*'DB_PASSWORD', 'PassWord'\s*\);/) }
  its(:content) { should match(/^\$table_prefix\s*=\s*'wp1_';$/) }
end

describe file salts_file do
  it { should exist }
  it { should be_owned_by user }
  it { should be_grouped_into group }
  it { should be_mode 440 }
  %w[ AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT ].each do |salt|
    its(:content) { should match(/^define\('#{salt}',\s*'[^']+'\)/) }
  end
end

plugins.each do |p|
  archive_file = if p.key?(:version)
                   "#{distfile_dir}/#{p[:name]}.#{p[:version]}.zip"
                 else
                   "#{distfile_dir}/#{p[:name]}.zip"
                 end
  describe file archive_file do
    it { should exist }
    it { should be_file }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    it { should be_mode 640 }
  end

  describe file "#{plugin_dir}/#{p[:name]}/#{p[:name]}.php" do
    it { should exist }
    it { should be_file }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    it { should be_mode 644 }
  end
end
