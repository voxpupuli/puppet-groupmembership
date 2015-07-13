Puppet::Type.type(:groupmembership).provide(:gpasswd, :parent => :default) do
  confine :kernel => [:linux]
  defaultfor :kernel => [:linux]

  def members=(value)
    if resource[:exclusive]
      execute(['/usr/bin/gpasswd', '-M', resource[:members].join(','), resource[:name]], :failonfail => false)
    else
      execute(['/usr/bin/gpasswd', '-m', resource[:members].join(','), resource[:name]], :failonfail => false)
    end
  end
end
