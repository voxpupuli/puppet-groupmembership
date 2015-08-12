Puppet::Type.type(:groupmembership).provide(:groupmod, :parent => :getent) do
  confine :kernel => [:sunos]
  defaultfor :kernel => [:sunos]

  def members=(value)
    member_list = resource[:members].sort.join(',')
    Puppet.debug("Setting membership on #{resource[:name]} to #{member_list}")
    if resource[:exclusive]
      execute(['/usr/sbin/groupmod', '-U', member_list, resource[:name]], :failonfail => false)
    else
      execute(['/usr/sbin/groupmod', '-U', '+' + member_list, resource[:name]], :failonfail => false)
    end
  end
end

