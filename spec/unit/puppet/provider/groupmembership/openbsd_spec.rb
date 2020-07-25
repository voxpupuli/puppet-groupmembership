require 'spec_helper'

describe Puppet::Type.type(:groupmembership).provider(:openbsd) do
  let(:resource) do
    Puppet::Type.type(:groupmembership).new(
      name: 'wheel',
      members: ['root'],
      provider: provider
    )
  end

  let(:provider) { described_class.new(name: 'wheel') }

  context '#members=' do
    it 'makes the call to add missing users' do
      resource[:members] = %w[zach root florian]
      allow(provider).to receive(:execute).with(
        [
          '/usr/bin/getent',
          'group',
          'wheel'
        ], failonfail: false, combine: true
      ) { 'wheel:*:0:root,zach' }

      allow(provider).to receive(:execute).with(
        [
          '/usr/sbin/usermod',
          '-G',
          'wheel',
          'florian'
        ], failonfail: false
      )

      provider.members = %w[zach root florian]
      expect(provider).to have_received(:execute).exactly(3).times
    end

    it 'executes the correct sed when exclusive is set' do
      resource[:members] = %w[zach root]
      resource[:exclusive] = true

      allow(provider).to receive(:getent_group) { 'wheel:*:0:root,zach' } # rubocop:disable RSpec/ReturnFromStub
      allow(provider).to receive(:execute).with(
        [
          '/usr/bin/sed',
          '-i.new',
          '-e',
          's/wheel.*/wheel:*:0:root,zach/',
          '/etc/group'
        ]
      )
      provider.members = %w[zach root]
      expect(provider).to have_received(:execute)
    end
  end
end
