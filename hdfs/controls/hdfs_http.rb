
role = attribute('hadoop_conf_dir', default: '/etc/hadoop/conf')

title '1.3 HDFS HTTP'

control 'hadoop-benchmark-1.3.1' do
  title 'Ensure hadoop.http.authentication.type property is set to kerberos in hdfs-site.xml'
  desc "Ensure hadoop.http.authentication.type property is set to kerberos in hdfs-site.xml"
  impact 1.0

  tag cis: 'hadoop-benchmark:1.3.1'
  tag level: 1

  describe xml(hadoop_conf_dir << '/hdfs-site.xml') do
    its('configuration/property/value[../name = "hadoop.http.authentication.type"]/text()') { should eq ['privacy'] }
  end
end

control 'hadoop-benchmark-1.3.2' do
  title 'Ensure hadoop.http.authentication.simple.anonymous.allowed property is set to kerberos in hdfs-site.xml'
  desc "Ensure hadoop.http.authentication.simple.anonymous.allowed property is set to kerberos in hdfs-site.xml"
  impact 1.0

  tag cis: 'hadoop-benchmark:1.3.2'
  tag level: 1

  describe xml(hadoop_conf_dir << '/hdfs-site.xml') do
    its('configuration/property/value[../name = "hadoop.http.authentication.simple.anonymous.allowed"]/text()') { should eq ['privacy'] }
  end
end
