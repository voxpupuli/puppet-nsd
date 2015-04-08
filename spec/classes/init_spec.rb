require 'spec_helper'
fact_sets = []

openbsd_facts = {
  :osfamily => 'OpenBSD',
  :operatingsystem => 'OpenBSD',
  :concat_basedir => '/dne',
  :id => 'root',
  :kernel => 'OpenBSD'
}

fact_sets << openbsd_facts

describe 'nsd' do
  context 'supported operatingsystems' do

    fact_sets.each {|f|
      describe "puppet class without any parameters on #{f[:operatingsystem]}" do
        let(:facts) { f }
        it { should contain_class('nsd') }
      end
    }
  end
end
