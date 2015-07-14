Puppet::Type.type(:groupmembership).provide(:getent) do
  desc "Manage a POSIX group's membership"

  confine :kernel => [:linux, :freebsd]

  def members
    output = getent_group()
    fields = output.split(':')
    member_list = fields[-1].split(',').map {|i| i.chomp }.reject {|i| i.size == 0 }.sort
    Puppet.debug("Current membership for #{resource[:name]} is #{member_list}")
    return member_list
  end

  def getent_group
    output = execute(['/usr/bin/getent', 'group', resource[:name]], :failonfail => false, :combine => true)
    return output
  end
end
