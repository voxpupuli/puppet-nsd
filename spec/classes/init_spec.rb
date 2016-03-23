require 'spec_helper'

fact_sets = []

openbsd_facts = {
  :osfamily => 'OpenBSD',
  :operatingsystem => 'OpenBSD',
  :concat_basedir => '/dne',
  :id => 'root',
  :kernel => 'OpenBSD',
  :is_pe => false,
  :path => "dummy",
}

freebsd_facts = {
  :osfamily => 'FreeBSD',
  :operatingsystem => 'FreeBSD',
  :concat_basedir => '/dne',
  :id => 'root',
  :kernel => 'FreeBSD',
  :is_pe => false,
  :path => "dummy",
}


fact_sets << openbsd_facts
fact_sets << freebsd_facts

describe 'nsd' do
  context 'supported operatingsystems' do

    fact_sets.each {|f|
      describe "puppet class without any parameters on #{f[:operatingsystem]}" do
        let(:facts) { f }
        it { should contain_class('nsd') }
        it { should contain_class('nsd::params') }
        it { should contain_service('nsd') }
        it { should contain_exec('nsd-control reconfig') }
        it { should contain_exec('nsd-control reload') }
      end
    }
  end
end
