

title '1.4 HDFS DataNode'

control 'hadoop-benchmark-1.4.1' do
  title 'Ensure hadoop.rpc.protection property is set to privacy in core-site.xml'
  desc "Property hadoop.rpc.protection enable Encrypted RPC by setting the value at privacy in core-site.xml."
  impact 1.0

  tag cis: 'hadoop-benchmark:1.4.1'
  tag level: 1

  only_if do
    file('/.../core-site.xml').exist?
  end

  describe xml('/.../core-site.xml') do
    its('configuration/property/value[../name = "hadoop.rpc.protection"]/text()') { should eq ['privacy'] }
  end
end


describe command('exit 123') do
  its('stdout') { should eq '' }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 123 }
end
