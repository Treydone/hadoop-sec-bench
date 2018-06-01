
role = attribute('hadoop_conf_dir', default: '/etc/hadoop/conf')

title '1.0 HDFS Common'

control 'hadoop-benchmark-1.0.1' do
  title 'Ensure hadoop.rpc.protection property is set to privacy in core-site.xml'
  desc "Property hadoop.rpc.protection enable Encrypted RPC by setting the value at privacy in core-site.xml."
  impact 1.0

  tag cis: 'hadoop-benchmark:1.0.1'
  tag level: 1

  describe xml(hadoop_conf_dir << '/core-site.xml') do
    its('configuration/property/value[../name = "hadoop.rpc.protection"]/text()') { should eq ['privacy'] }
  end
end

control 'hadoop-benchmark-1.0.2' do
  title 'Ensure data transfer protocol is enabled'
  desc "Property hadoop.rpc.protection enable Encrypted RPC by setting the value at privacy in core-site.xml."
  impact 1.0

  tag cis: 'hadoop-benchmark:1.0.2'
  tag level: 1

  describe xml(hadoop_conf_dir << '/core-site.xml') do
    its('configuration/property/value[../name = "dfs.encrypt.data.transfer"]/text()') { should eq ['true'] }
  end
  describe xml(hadoop_conf_dir << '/core-site.xml') do
    its('configuration/property/value[../name = "dfs.encrypt.data.transfer.algorithm"]/text()') { should eq ['3des'] }
  end
end
