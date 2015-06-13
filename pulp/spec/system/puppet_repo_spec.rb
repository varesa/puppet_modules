require 'spec_helper_system'

describe 'puppet repo type' do

  before do
    manifest = %q{
      class {'pulp': }
      class {'pulp::server': }
      class {'pulp::admin_client': }
    }

    puppet_apply manifest
  end

  context do
    it 'should create a bare repo' do
      manifest = %q{
        puppet_repo { 'test-repo':
          ensure => 'present',
          login => 'admin',
          password => 'admin'
        }
      }

      puppet_apply manifest do |r|
        expect(r.exit_code).to eq 2
        expect(r.stderr).to be_empty
      end

      shell 'pulp-admin puppet repo list' do |r|
        expect(r.stdout).to match /Id:\s*test-repo/
      end
    end

    it 'should update repos' do
      puppet_apply = %q{
        puppet_repo { 'test-repo':
          ensure => 'present',
          login => 'admin',
          password => 'admin'
        }
      }

      manifest = %q{
        puppet_repo { 'test-repo':
          ensure => 'present',
          display_name => 'test display name',
          description => 'test description',
          feed => 'http://feed.com',
          notes => {'name1' => 'value 1', 'name2' => 'value 2'},
          queries => ['test query 1', 'test query 2'],
          schedules => [ '2012-12-15T00:00Z/P1D', '2012-12-16T00:00Z/P1D' ],
          serve_http => true,
          serve_https => true,
          login => 'admin',
          password => 'admin'
        }
      }

      puppet_apply manifest do |r|
        expect(r.stderr).to be_empty
        expect(r.exit_code).to eq 2
      end

      shell 'pulp-admin puppet repo list --detail' do |r|
        expect(r.stdout).to match /^Id:\s*test-repo$/
        expect(r.stdout).to match /^Display Name:\s*test display name$/
        expect(r.stdout).to match /^Description:\s*test description$/
        expect(r.stdout).to match /^  Name1: value 1$/
        expect(r.stdout).to match /^  Name2: value 2$/
        expect(r.stdout).to match /^    Queries: test query 1, test query 2$/
        expect(r.stdout).to match /^    Feed:\s*http:\/\/feed\.com$/
        expect(r.stdout).to match /^    Serve Http:  True$/
        expect(r.stdout).to match /^    Serve Https: True$/
        expect(r.stdout).to match /^  Scheduled Syncs:\s*2012-12-15T00:00Z\/P1D, 2012-12-16T00:00Z\/P1D/
      end
    end

    it 'should create repos' do
     manifest = %q{
      puppet_repo { 'test-repo':
          ensure => 'present',
          display_name => 'test display name',
          description => 'test description',
          feed => 'http://feed.com',
          notes => {'name1' => 'value 1', 'name2' => 'value 2'},
          queries => ['test query 1', 'test query 2'],
          schedules => [ '2012-12-15T00:00Z/P1D', '2012-12-16T00:00Z/P1D' ],
          serve_http => true,
          serve_https => true,
          login => 'admin',
          password => 'admin'
        }
      }

      puppet_apply manifest do |r|
        expect(r.stderr).to be_empty
        expect(r.exit_code).to eq 2
      end

      shell 'pulp-admin puppet repo list --detail' do |r|
        expect(r.stdout).to match /^Id:\s*test-repo$/
        expect(r.stdout).to match /^Display Name:\s*test display name$/
        expect(r.stdout).to match /^Description:\s*test description$/
        expect(r.stdout).to match /^  Name1: value 1$/
        expect(r.stdout).to match /^  Name2: value 2$/
        expect(r.stdout).to match /^    Queries: test query 1, test query 2$/
        expect(r.stdout).to match /^    Feed:\s*http:\/\/feed\.com$/
        expect(r.stdout).to match /^    Serve Http:  True$/
        expect(r.stdout).to match /^    Serve Https: True$/
        expect(r.stdout).to match /^  Scheduled Syncs:\s*2012-12-15T00:00Z\/P1D, 2012-12-16T00:00Z\/P1D/
      end
    end

    it 'should update schedules' do
     manifest = %q{
      puppet_repo { 'test-repo':
          ensure => 'present',
          login => 'admin',
          password => 'admin',
          schedules => [ '2012-12-15T00:00Z/P1D', '2012-12-16T00:00Z/P1D' ]
        }
      }

      puppet_apply manifest do |r|
        expect(r.stderr).to be_empty
        expect(r.exit_code).to eq 2
      end

      shell 'pulp-admin puppet repo list --detail' do |r|
        expect(r.stdout).to match /^  Scheduled Syncs:\s*2012-12-15T00:00Z\/P1D, 2012-12-16T00:00Z\/P1D/
      end

     manifest = %q{
      puppet_repo { 'test-repo':
          ensure => 'present',
          login => 'admin',
          password => 'admin',
          schedules => [ '2012-12-17T00:00Z/P1D' ]
        }
      }

      puppet_apply manifest do |r|
        expect(r.stderr).to be_empty
        expect(r.exit_code).to eq 2
      end

      shell 'pulp-admin puppet repo list --detail' do |r|
        expect(r.stdout).to match /^  Scheduled Syncs:\s*2012-12-17T00:00Z\/P1D/
      end
    end

    it 'should be idempotent' do
      manifest = %q{
        puppet_repo { 'test-repo':
          ensure => 'present',
          login => 'admin',
          password => 'admin'
        }
      }

      puppet_apply manifest do |r|
        expect(r.exit_code).to eq 2
        expect(r.stderr).to be_empty
      end

      puppet_apply manifest do |r|
        expect(r.exit_code).to eq 0
        expect(r.stderr).to be_empty
      end
    end

    it 'should remove repos' do
      puppet_apply %q{
        puppet_repo { 'test-repo':
          ensure => 'present',
          login => 'admin',
          password => 'admin'
        }
      }
      puppet_apply %q{
        puppet_repo { 'test-repo':
          ensure => 'absent',
          login => 'admin',
          password => 'admin'
        }
      }

      shell 'pulp-admin puppet repo list' do |r|
        expect(r.stdout).to_not match /Id:\s*test-repo/
      end
    end

    after { shell 'pulp-admin puppet repo delete --repo-id=test-repo' }
  end
end
