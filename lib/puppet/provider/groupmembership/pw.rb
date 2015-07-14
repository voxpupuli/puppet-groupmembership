Puppet::Type.type(:groupmembership).provide(:pw, :parent => :default) do
  confine :kernel => [:freebsd]
  defaultfor :kernel => [:freebsd]

  def members=(value)
    if resource[:exclusive]
      execute(['/usr/sbin/pw', 'group', 'mod', '-M', resource[:members].join(','), resource[:name]], :failonfail => false)
    else
      pw(['group', 'mod', '-m', resource[:members].join(','), resource[:name]])
    end
  end
end

