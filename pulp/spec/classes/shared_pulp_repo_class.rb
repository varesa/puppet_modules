require 'spec_helper'

shared_context :pulp_repo_class_enabled do
  it do
    should contain_class('pulp::repo').with({
      :ensure => 'enabled',
      :stage  => 'pulp_repo_setup'
    })
  end
end

shared_context :pulp_repo_class_disabled do
  it do
    should contain_class('pulp::repo').with({
      :ensure => 'disabled',
      :stage  => 'pulp_repo_setup'
    })
  end
end

shared_context :pulp_repo_class_absent do
  it do
    should contain_class('pulp::repo').with({
      :ensure => 'absent',
      :stage  => 'pulp_repo_setup'
    })
  end
end
