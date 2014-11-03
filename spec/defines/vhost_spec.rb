require 'spec_helper'

describe 'apache::vhost', :type => :define do
  let :facts do
    { :fqdn => 'localhost.test' }
  end
  let :title do
    'vhost.test' 
  end
  let :pre_condition do
    'class { "apache": }'
  end
  context "on RedHat" do
    let :facts do
      super().merge({ :osfamily => 'RedHat'})
    end
    it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_ensure /present|file/  }
    it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_content /ServerName "?vhost.test"?/ }

    it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_content /Listen "?80"?/ }
    it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_content /<VirtualHost .*:80>/ }

    context 'with ensure => absent' do
      let :params do 
        { :ensure => 'absent' }
      end
      it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_ensure 'absent' }
    end

    context 'with port => 8081' do
      let :params do 
        { :port => 8081 }
      end
      it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_content /Listen "?8081"?/ }
      it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_content /<VirtualHost .*:8081>/ }
    end

    context "with documentroot => '/tmp'" do
      let :params do
        { :documentroot => '/tmp' }
      end
      it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_content %r{DocumentRoot "?/tmp"?} }
    end

    context "with errorlog => '/tmp/vhost.log'" do
      let :params do
        { :errorlog => '/tmp/vhost.log' }
      end
      it { is_expected.to contain_file('/etc/httpd/conf.d/vhost.test.conf').with_content %r{ErrorLog "?/tmp/vhost.log"?} }
    end

    describe 'with input validation' do

      context 'ensure => fail' do
        let :params do 
          { :ensure => 'fail' }
        end
        it { expect { is_expected.not_to compile }.to raise_error(Puppet::Error, /must be ["']?present["']? or ["']?absent["']?/) }
      end

      fail_port = [ 'abcd', '!', -1, 65536 ].each do |port|
        context "port => #{port}" do
          let :params do 
            { :port => port }
          end
          it { expect { is_expected.not_to compile }.to raise_error(Puppet::Error, /must be an integer|not a port/) }
        end
      end

      context "documentroot => '~/www'" do
        let :params do
          { :documentroot => '~/www' }
        end
        it { expect { is_expected.not_to compile }.to raise_error(Puppet::Error, /not an absolute path/) }
      end

      context "errorlog => 'logs/vhost.log'" do
        let :params do
          { :errorlog => 'logs/vhost.log' }
        end
        it { expect { is_expected.not_to compile }.to raise_error(Puppet::Error, /not an absolute path/) }
      end
    end
  end

  context "on Debian" do
    let :facts do
      super().merge({ :osfamily => 'Debian' })
    end

    it { is_expected.to contain_file('/etc/apache2/sites-available/vhost.test.conf').with_ensure /present|file/ }
    it { is_expected.to contain_file('/etc/apache2/sites-enabled/vhost.test.conf').with({
        :ensure => 'link',
        :target => '../sites-available/vhost.test.conf',
      })
    }

    context 'with ensure => absent' do
      let :params do 
        { :ensure => 'absent' }
      end
      it { is_expected.to contain_file('/etc/apache2/sites-enabled/vhost.test.conf').with_ensure 'absent' }
    end
  end
end
