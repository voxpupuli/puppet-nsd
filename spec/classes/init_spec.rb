# frozen_string_literal: true

require 'spec_helper'

describe 'nsd' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default params' do
        it { is_expected.to contain_class('nsd') }
        it { is_expected.to contain_service('nsd') }
        it { is_expected.to contain_exec('nsd-control reconfig') }
        it { is_expected.to contain_exec('nsd-control reload') }
      end
    end
  end
end
