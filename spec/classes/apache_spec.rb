require 'spec_helper'

describe 'apache' do
  let(:facts) {{ :fqdn => 'localhost.test' }}
  context "on RedHat" do
    let :facts do
      super().merge({ :osfamily => 'RedHat' })
    end

    it { is_expected.to contain_package('httpd').with_ensure 'installed' }

    package_versions = ['installed', 'latest', '2.2.15']
    package_versions.each do |version|
      context "with version => '#{version}'" do
        let :params do 
          { :version => version }
        end
        it { is_expected.to contain_package('httpd').with_ensure version }
      end
    end

    it { is_expected.to contain_service('httpd').with
      {
        :ensure  => 'running',
        :enable  => true,
      }
    }

    it { is_expected.to  contain_file('/etc/httpd/conf/httpd.conf').with_ensure 'file' }

    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /ServerName "?localhost.test"?/ }

    context "with servername => 'http://localhost:80'" do
      let :params do 
        { :servername => 'http://localhost:80' }
      end
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{ServerName "?http://localhost:80"?} }
    end

    ##Good tests, but distracting for this class
    #protocols = [ '', 'http://', 'ftp://' ]
    #hostnames = [
    #  'localhost',
    #  'localhost.localdomain',
    #  '1.2.3.4',
    #]
    #ports = [ '', ':80', ':8080' ]
    #
    #protocols.each do |protocol|
    #  hostnames.each do |hostname|
    #    ports.each do |port|
    #      servername = "#{protocol}#{hostname}#{port}"
    #      context "with servername => '#{servername}'" do
    #        let :params do
    #          { :servername => servername }
    #        end
    #        it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /ServerName "?servername"?/ }
    #      end
    #    end
    #  end
    #end
  
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /Listen "?80"?/ }

    context "with listen => '8081'" do
      let :params do
        { :listen => 8081 }
      end
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /Listen "?8081"?/ }
    end
    
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{ErrorLog "?/var/log/httpd/error.log"?} }

    context "with errorlog => '/tmp/error.log'" do
      let :params do
        { :errorlog => '/tmp/error.log' }
      end
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{ErrorLog "?/tmp/error.log"?} }
    end
    
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /User "?apache"?/ }

    context "with user => 'nobody'" do
      let :params do
        { :user => 'nobody' }
      end
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /User "?nobody"?/ }
    end
    
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /Group "?apache"?/ }

    context "with group => 'nobody'" do
      let :params do
        { :group => 'nobody' }
      end
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /Group "?nobody"?/ }
    end
    
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{LoadModule dir_module modules/mod_dir.so} }
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{LoadModule mime_module modules/mod_mime.so} }
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{LoadModule autoindex_module modules/mod_autoindex.so} }
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{TypesConfig "?/etc/mime.types"?} }
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /DirectoryIndex "?index.html"?/ }
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /Options \+Indexes/ }


    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{DocumentRoot "?/var/www/html/?"?} }

    context "with documentroot => '/tmp'" do
      let :params do
        { :documentroot => '/tmp' }
      end
      it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{DocumentRoot "?/tmp"?} }
    end
    
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content /LogLevel "?warn"?/ }
    it { is_expected.to contain_file('/etc/httpd/conf/httpd.conf').with_content %r{Include "?conf.d/\*\.conf"?} }

    describe 'with input validation' do
      ##Input validation doesn't currently catch this.
      #context "with version='!'" do
      #  let :params do
      #    { :version => '!' }
      #  end
      #  it { expect { is_expected.not_to compile }.to raise_error(Puppet::Error, /validate_re/) }
      #end

      context "servername => '!'" do
        let :params do
          { :servername => '!' }
        end
        it { expect { is_expected.not_to compile }.to raise_error(Puppet::Error, /validate_re/) }
      end

      ##Good tests, but distracting for this class
      #protocols = [ '', 'http:/', '://', 'http:', '1://', '//:' ]
      #hostnames = [ '', 'localhost' ]
      #ports     = [ '', ':', ':80' ]
      #
      #protocols.each do |protocol|
      #  hostnames.each do |hostname|
      #    ports.each do |port|
      #      servername = "#{protocol}#{hostname}#{port}"
      #        unless servername == 'localhost' || servername == 'localhost:8080'
      #          context "servername => '#{servername}'" do
      #          let :params do
      #            { :servername => servername }
      #          end
      #          it { expect{ is_expected.not_to compile }.to raise_error(Puppet::Error, /validate_re/) }
      #        end
      #      end
      #    end
      #  end
      #end
      
      context "listen => '!'" do
        let :params do
          { :listen => '!' }
        end
        it { expect { is_expected.not_to compile }.to raise_error(Puppet::Error, /must be an integer|not a port/) }
      end

      context "errorlog => 'logs/error.log'" do
        let :params do
          { :errorlog => 'logs/error.log' }
        end
        it { expect{ is_expected.not_to compile }.to raise_error(Puppet::Error, /not an absolute path/) }
      end

      context "user => '!'" do
        let :params do
          { :user => '!' }
        end
        it { expect{ is_expected.not_to compile }.to raise_error(Puppet::Error, /validate_re/) }
      end

      context "group => '!'" do
        let :params do
          { :group => '!' }
        end
        it { expect{ is_expected.not_to compile }.to raise_error(Puppet::Error, /validate_re/) }
      end

      context "documentroot => 'html'" do
        let :params do
          { :documentroot => 'html' }
        end
        it { expect{ is_expected.not_to compile }.to raise_error(Puppet::Error, /not an absolute path/) }
      end
    end
  end

  context "on Debian" do
    let :facts do
      super().merge({ :osfamily => 'Debian' })
    end

    it { is_expected.to contain_package('apache2').with_ensure 'installed' }

    it { is_expected.to contain_service('apache2').with({
        :ensure  => 'running',
        :enable  => true,
      })
    }

    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_ensure 'file' }

    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content /User "?www-data"?/ }
    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content /Group "?www-data"?/ }

    it { is_expected.to contain_file('/etc/apache2/apache2.conf').without_content %r{LoadModule dir_module modules/mod_dir.so} }
    it { is_expected.to contain_file('/etc/apache2/apache2.conf').without_contnet %r{LoadModule dir_module modules/mod_mime.so} }
    it { is_expected.to contain_file('/etc/apache2/apache2.conf').without_content %r{LoadModule dir_module modules/mod_autoindex.so} }

    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{Include "?mods-enabled/\*\.load"?} }
    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{Include "?mods-enabled/\*\.conf"?} }

    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{DocumentRoot "?/var/www/?"?} }

    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content /LogLevel "?warn"?/ }
    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{ErrorLog "?/var/log/apache2/error.log"?} }

    it { is_expected.to contain_file('/etc/apache2/apache2.conf').with_content %r{Include "?sites-enabled/"?} }
  end
end
