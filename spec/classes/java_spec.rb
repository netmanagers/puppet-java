require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'java' do

  let(:title) { 'java' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42',
                  :operatingsystem => 'Debian' } }

  describe 'Test minimal installation - openjdk - Debian' do
    it { should contain_package('openjdk-7-jre-headless').with_ensure('present') }
  end

  describe 'Test minimal installation - openjdk - CentOS' do
    let(:facts) { {:operatingsystem => 'CentOS' } }
    it { should contain_package('java-1.7.0-openjdk').with_ensure('present') }
  end

  describe 'Test minimal installation - openjdk - Different major version' do
    let(:params) { {:major_version => '3' } }
    it { should contain_package('openjdk-3-jre-headless').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:major_version => '3',
                    :version => '1.0.42' } }
    it { should contain_package('openjdk-3-jre-headless').with_ensure('1.0.42') }
  end

  describe 'Test installation - Oracle ' do
    let(:params) { {:package_provider     => 'oracle',
                    :oracle_package       => 'jre-7u21-linux-x64.rpm',
                    :oracle_exec_env      => 'some_var=some_value',
                    :oracle_extracted_dir => '/usr/lib/jvm/j2re1.7-oracle',
                    :oracle_repo_url      => 'http://www.example.com/java'} }
    it { should contain_puppi__netinstall('netinstall_oracle_java').with_url('http://www.example.com/java/jre-7u21-linux-x64.rpm')}
    it { should contain_puppi__netinstall('netinstall_oracle_java').with_extract_command('dpkg -i') }
    it { should contain_puppi__netinstall('netinstall_oracle_java').with_exec_env('some_var=some_value') }
    it { should contain_puppi__netinstall('netinstall_oracle_java').with_extracted_dir('/usr/lib/jvm/j2re1.7-oracle') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true } }
    it 'should remove Package[java]' do should contain_package('openjdk-7-jre-headless').with_ensure('absent') end 
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('openjdk-7-jre-headless').with_noop('true') }
  end

end
