Puppet::Type.type(:groupmembership).provide(:pw, :parent => :getent) do
  confine :kernel => [:freebsd]
  defaultfor :kernel => [:freebsd]

  def members=(value)
    member_list = resource[:members].sort.join(',')
    Puppet.debug("Setting membership on #{resource[:name]} to #{member_list}")
    if resource[:exclusive]
      execute(['/usr/sbin/pw', 'group', 'mod', resource[:name], '-M', member_list], :failonfail => false)
    else
      execute(['/usr/sbin/pw', 'group', 'mod', resource[:name], '-m', member_list], :failonfail => false)
    end
  end
end

