require 'spec_helper'

type_class = Puppet::Type.type(:groupmembership)
provider_class = type_class.provider(:getent)

describe provider_class do
  context '#members' do
    context 'with a single group member' do
      let!(:info) { 'wheel:*:0:root' }
      let!(:resource) do
        Puppet::Type.type(:groupmembership).new(
          name: 'wheel',
          provider: 'getent',
          members: ['root'],
          exclusive: :false
        )
      end

      before do
        allow(resource.provider).to receive(:getent_group) { info }
      end

      it 'returns the members' do
        expect(resource.provider.members).to eq(['root'])
      end
    end

    context 'with multiple group members' do
      let!(:info) { 'wheel:*:0:root,foo,bar' }
      let!(:resource) do
        Puppet::Type.type(:groupmembership).new(
          name: 'wheel',
          provider: 'getent',
          members: ['root'],
          exclusive: :false
        )
      end

      before do
        allow(resource.provider).to receive(:getent_group) { info }
      end

      it 'returns the members' do
        expect(resource.provider.members).to eq(%w[root foo bar].sort)
      end
    end
  end
end
