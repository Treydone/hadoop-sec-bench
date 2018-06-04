role = attribute('hadoop_conf_dir', default: '/etc/hadoop/conf')

title '0.0 Common'

control 'hadoop-benchmark-1.0.1' do
  title 'THP Disabled'
  desc "THP Disabled"
  impact 1.0

  tag perf: 'hadoop-benchmark:1.0.1'
  tag level: 1

  if os.redhat? || os.name == 'fedora'
    describe command('cat /sys/kernel/mm/redhat_transparent_hugepage/enabled') do
      its(:stdout) { should contain('[never]') }
    end
  elsif os.debian? || os.suse?
    describe command('cat /sys/kernel/mm/transparent_hugepage/enabled') do
      its(:stdout) { should contain('[never]') }
    end
  end

end
