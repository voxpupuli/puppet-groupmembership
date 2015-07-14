require 'spec_helper'

type_class = Puppet::Type.type(:groupmembership)

describe type_class do
  context 'parameters' do
    rec = type_class.new(:name => 'wheel', :members => ['root']).parameters
    subject { rec }

    it { should have_key(:exclusive) }
    it { should have_key(:members) }
  end
end
