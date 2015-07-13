Puppet::Type.type(:groupmembership).provide(:gpasswd, :parent => :default) do
  confine :kernel => [:linux]
  defaultfor :kernel => [:linux]

  commands :gpasswd => '/usr/bin/gpasswd'

  def members=(value)
    if resource[:exclusive]
      gpasswd(['-M', resource[:members].join(',')])
    else
      gpasswd(['-m', resource[:members].join(',')])
    end
  end
end
