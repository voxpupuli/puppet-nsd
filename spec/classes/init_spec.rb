# frozen_string_literal: true

require 'spec_helper'

describe 'nsd' do
  let(:params) { {} }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      case facts[:os]['family']
      when 'OpenBSD'
        let(:config_d) { '/var/nsd/etc' }
        let(:config_file) { '/var/nsd/etc/nsd.conf' }
        let(:zonedir) { '/var/nsd/zones' }
        let(:service_name) { 'nsd' }
        let(:owner) { '_nsd' }
        let(:group) { '_nsd' }
        let(:control_cmd) { 'nsd-control' }
        let(:database) { '/var/nsd/db/nsd.db' }
      when 'FreeBSD'
        let(:config_d) { '/usr/local/etc/nsd' }
        let(:config_file) { '/usr/local/etc/nsd/nsd.conf' }
        let(:zonedir) { '/usr/local/etc/nsd' }
        let(:service_name) { 'nsd' }
        let(:owner) { 'nsd' }
        let(:group) { 'nsd' }
        let(:control_cmd) { 'nsd-control' }
        let(:database) { '/var/db/nsd/nsd.db' }
      end

      let(:facts) { facts }
      let(:package_name) { 'nsd' }

      context 'with default params' do
        it { is_expected.to contain_class('nsd') }
        it { is_expected.to contain_service('nsd') }
        it { is_expected.to contain_exec('nsd-control reconfig') }
        it { is_expected.to contain_exec('nsd-control reload') }
      end
    end
  end
end
