Puppet::Type.type(:groupmembership).provide(:gpasswd, :parent => :default) do
  confine :kernel => [:linux]
  defaultfor :kernel => [:linux]

  def members=(value)
    member_list = resource[:members].join(',').sort
    Puppet.debug("Setting membership on #{resource[:name]} to #{member_list.sort}")
    if resource[:exclusive]
      execute(['/usr/bin/gpasswd', '-M', member_list, resource[:name]], :failonfail => false)
    else
      execute(['/usr/bin/gpasswd', '-m', member_list, resource[:name]], :failonfail => false)
    end
  end
end
