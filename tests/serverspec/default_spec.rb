require "spec_helper"
require "serverspec"

config  = "/home/vagrant/"
user    = "wordpress_hosted"
group   = "wordpress_hosted"
ports   = [PORTS]
log_dir = "/var/log/wordpress_hosted"
db_dir  = "/var/lib/wordpress_hosted"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/wordpress_hosted.conf"
  db_dir = "/var/db/wordpress_hosted"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("wordpress_hosted") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/wordpress_hosted") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
