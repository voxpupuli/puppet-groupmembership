Puppet::Type.type(:groupmembership).provide(:pw, :parent => :default) do
  confine :kernel => [:freebsd]
  defaultfor :kernel => [:freebsd]

  commands :pw => '/usr/sbin/pw'

  def members=(value)
    if resource[:exclusive]
      pw(['group', 'mod', '-M', resource[:members].join(',')])
    else
      pw(['group', 'mod', '-m', resource[:members].join(',')])
    end
  end
end

