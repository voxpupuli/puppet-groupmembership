require 'spec_helper'

describe Puppet::Type.type(:groupmembership).provider(:dscl) do
  let(:resource) do
    Puppet::Type.type(:groupmembership).new(
      name: 'wheel',
      members: ['root'],
      provider: provider
    )
  end

  let(:provider) { described_class.new(name: 'wheel') }

  context '#parse_plist' do
    wheel_group_xml = File.read('spec/fixtures/dscl_group_read_single.plist')
    it 'has the correct members' do
      expect(described_class.parse_plist(wheel_group_xml)['dsAttrTypeStandard:GroupMembership']).to eq(['root'])
    end

    admin_group_xml = File.read('spec/fixtures/dscl_group_read_multi.plist')
    it 'has the correct members' do
      expect(described_class.parse_plist(admin_group_xml)['dsAttrTypeStandard:GroupMembership']).to eq(%w[root zach])
    end
  end

  context '#members=' do
    it 'makes the call to add missing members' do
      allow(provider).to receive(:members) { %w[root zach] }
      resource[:members] = %w[zach root florian]
      expect(provider).to receive(:execute).with(
        [
          '/usr/bin/dscl',
          '.',
          '-append',
          '/Groups/wheel',
          'GroupMembership',
          'florian'
        ],
        failonfail: false
      )
      provider.members = %w[zach root florian]
    end

    context 'with exclusive' do
      it 'makes the call to remove extra members' do
        allow(provider).to receive(:members) { %w[root zach florian] }
        resource[:members] = %w[zach root]
        resource[:exclusive] = :true
        expect(provider).to receive(:execute).with(
          [
            '/usr/bin/dscl',
            '.',
            '-delete',
            '/Groups/wheel',
            'GroupMembership',
            'florian'
          ],
          failonfail: false
        )
        provider.members = %w[zach root]
      end
    end
  end
end
