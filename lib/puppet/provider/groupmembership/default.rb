Puppet::Type.type(:groupmembership).provide(:default) do
  desc "Manage a POSIX group's membership"

  #commands :getent => '/usr/bin/getent'

  def members
    output = execute(['/usr/bin/getent', 'group', resource[:name]], :failonfail => false, :combine => true)
    fields = output.split(':', 4)
    member_list = fields[-1].split(',')
    return member_list
  end
end
