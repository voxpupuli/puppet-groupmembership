# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'groupmembership' do
  before(:all) do
    shell('groupadd trees && useradd -M oak && useradd -M elm && useradd -M ash && gpasswd -a ash trees', acceptable_exit_codes: [0, 9])
  end

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        groupmembership { 'trees':
          members   => ['oak', 'elm'],
          exclusive => true,
        }
      PUPPET
    end
  end

  describe group('trees') do
    it { is_expected.to exist }
  end

  describe command('getent group trees') do
    its(:stdout) { is_expected.to match %r{^trees:x:\d+:(elm,oak|oak,elm)$} }
  end
end
