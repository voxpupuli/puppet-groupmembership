require 'spec_helper'

describe Puppet::Type.type(:groupmembership).provider(:pw) do
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
      allow(resource.provider).to receive(:execute).with(
        [
          '/usr/bin/getent',
          'group',
          'wheel'
        ], failonfail: false, combine: true
      ) { 'wheel:*:0:root,zach' }

      allow(resource.provider).to receive(:execute).with(
        [
          '/usr/sbin/pw',
          'group',
          'mod',
          'wheel',
          '-m',
          'florian,root,zach'
        ], failonfail: false
      )

      resource.provider.members = %w[zach root florian]
    end

    it 'executes the correct sed when exclusive is set' do
      resource[:members] = %w[zach root]
      resource[:exclusive] = true

      allow(provider).to receive(:getent_group) { 'wheel:*:0:root,zach' } # rubocop:disable RSpec/ReturnFromStub
      allow(resource.provider).to receive(:execute).with(
        [
          '/usr/sbin/pw',
          'group',
          'mod',
          'wheel',
          '-M',
          'root,zach'
        ], failonfail: false
      )
      provider.members = %w[zach root]
    end
  end
end
