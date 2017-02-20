Puppet::Type.type(:groupmembership).provide(:gpasswd, parent: :getent) do
  confine kernel: [:linux]
  defaultfor kernel: [:linux]

  def members=(value)
    member_list = value.sort.join(',')
    Puppet.debug("Setting membership on #{resource[:name]} to #{member_list}")
    if resource[:exclusive]
      execute(['/usr/bin/gpasswd', '-M', member_list, resource[:name]], failonfail: false)
    else
      execute(['/usr/bin/gpasswd', '-m', member_list, resource[:name]], failonfail: false)
    end
  end
end
