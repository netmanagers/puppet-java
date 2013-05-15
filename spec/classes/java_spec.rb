require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'java' do

  let(:title) { 'java' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42',
                  :operatingsystem => 'Debian' } }

  describe 'Test minimal installation - openjdk - Debian' do
    it { should contain_package('openjdk-7-jre-headless').with_ensure('present') }
    it { should contain_file('java.conf').with_ensure('present') }
  end

  describe 'Test minimal installation - openjdk - CentOS' do
    let(:facts) { {:operatingsystem => 'CentOS' } }
    it { should contain_package('java-1.7.0-openjdk').with_ensure('present') }
    it { should contain_file('java.conf').with_ensure('present') }
  end

  describe 'Test minimal installation - openjdk - Different major version' do
    let(:params) { {:major_version => '3' } }
    it { should contain_package('openjdk-3-jre-headless').with_ensure('present') }
    it { should contain_file('java.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:major_version => '3',
                    :version => '1.0.42' } }
    it { should contain_package('openjdk-3-jre-headless').with_ensure('1.0.42') }
  end

  describe 'Test installation - Oracle ' do
    let(:params) { {:package_provider => 'oracle',
                    :oracle_package   => 'jre-7u21-linux-x64.rpm',
                    :oracle_repo_url  => 'http://www.example.com/java'} }
    it { should contain_puppi__netinstall('netinstall_oracle_java').with_url('http://www.example.com/java/jre-7u21-linux-x64.rpm')}
    it { should contain_puppi__netinstall('netinstall_oracle_java').with_postextract_command('dpkg -i') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true } }
    it 'should remove Package[java]' do should contain_package('openjdk-7-jre-headless').with_ensure('absent') end 
    it 'should remove java.configuration file' do should contain_file('java.conf').with_ensure('absent') end
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('openjdk-7-jre-headless').with_noop('true') }
    it { should contain_file('java.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "java/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'java.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'java.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/java/spec"} }
    it { should contain_file('java.conf').with_source('puppet:///modules/java/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/java/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('java.dir').with_source('puppet:///modules/java/dir/spec') }
    it { should contain_file('java.dir').with_purge('true') }
    it { should contain_file('java.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "java::spec" } }
    it { should contain_file('java.conf').with_content(/rspec.example42.com/) }
  end

end
