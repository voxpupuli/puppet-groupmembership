require 'spec_helper'

type_class = Puppet::Type.type(:groupmembership)

describe type_class do
  context 'parameters' do
    rec = type_class.new(name: 'wheel', members: ['root']).parameters
    subject { rec }

    it { is_expected.to have_key(:exclusive) }
    it { is_expected.to have_key(:members) }
  end
end
