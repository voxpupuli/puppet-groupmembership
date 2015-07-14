Puppet::Type.type(:groupmembership).provide(:pw, :parent => :default) do
  confine :kernel => [:freebsd]
  defaultfor :kernel => [:freebsd]

  def members=(value)
    member_list = resource[:members].sort.join(',')
    Puppet.debug("Setting membership on #{resource[:name]} to #{member_list}")
    if resource[:exclusive]
      execute(['/usr/sbin/pw', 'group', 'mod', '-M', resource[:members].join(','), resource[:name]], :failonfail => false)
    else
      execute(['/usr/sbin/pw', 'group', 'mod', '-m', resource[:members].join(','), resource[:name]], :failonfail => false)
    end
  end
end

