Puppet::Type.type(:groupmembership).provide(:default) do
  desc "Manage a POSIX group's membership"

  def members
    output = getent_group()
    fields = output.split(':')
    member_list = fields[-1].split(',').map {|i| i.chomp }
    Puppet.debug("Current membership for #{resource[:name]} is #{member_list.sort}")
    return member_list.sort
  end

  def getent_group
    output = execute(['/usr/bin/getent', 'group', resource[:name]], :failonfail => false, :combine => true)
    return output
  end
end
