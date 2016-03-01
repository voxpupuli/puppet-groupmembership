require 'spec_helper'

describe Puppet::Type.type(:groupmembership).provider(:openbsd) do

  let(:resource) do
    Puppet::Type.type(:groupmembership).new(
      :name => 'wheel',
      :members => ['root'],
      :provider => provider,
    )
  end
  let(:provider) { described_class.new(:name => 'wheel') }

  context '#members=' do
    it 'should make the call to add missing users' do
      resource[:members] = ['zach', 'root', 'florian']
      expect(provider).to receive(:getent_group).twice { 'wheel:*:0:root,zach' }
      provider.expects(:execute).with([
        '/usr/bin/getent',
        'group',
        'wheel'], {:failonfail => false}) { 'wheel:*:0:root,zach' }
      provider.expects(:execute).with([
        '/usr/sbin/usermod',
        '-G',
        'wheel',
        'florian'], {:failonfail => false})
      provider.members = ['zach', 'root', 'florian']
    end

    it 'should execute the correct sed when exclusive is set' do
      resource[:members] = ['zach', 'root']
      resource[:exclusive] = true

      expect(provider).to receive(:getent_group) { 'wheel:*:0:root,zach' }
      provider.expects(:execute).with([
        '/usr/bin/sed',
        '-i.new',
        '-e',
        's/wheel.*/wheel:*:0:root,zach/',
        '/etc/group'])
      provider.members = ['zach', 'root']
    end
  end

end
