
role = attribute('hadoop_conf_dir', default: '/etc/hadoop/conf')

title '2.3 HBase HTTP'

control 'hadoop-benchmark-2.3.1' do
  title 'Ensure hbase.security.authentication.ui property is set to kerberos in hbase-site.xml'
  desc "Ensure hbase.security.authentication.ui property is set to kerberos in hbase-site.xml"
  impact 1.0

  tag cis: 'hadoop-benchmark:2.3.1'
  tag level: 1

  describe xml(hadoop_conf_dir << '/hbase-site.xml') do
    its('configuration/property/value[../name = "hbase.security.authentication.ui"]/text()') { should eq ['privacy'] }
  end
end
