Puppet::Type.type(:groupmembership).provide(:getent) do
  desc "Manage a POSIX group's membership"

  confine :kernel => [:linux, :freebsd]

  def members
    output = getent_group()
    fields = output.split(':')

    if fields.size < 4
      member_list = []
    else
      # group:pw:gid:u1,u2
      member_list = fields[3].split(',').map {|i| i.chomp }.reject {|i| i.size == 0 }.sort
    end

    Puppet.debug("Current membership for #{resource[:name]} is #{member_list}")
    return member_list
  end

  def getent_group
    output = execute(['/usr/bin/getent', 'group', resource[:name]], :failonfail => false, :combine => true)
    return output
  end
end
