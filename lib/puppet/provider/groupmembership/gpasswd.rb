Puppet::Type.type(:groupmembership).provide(:gpasswd, :parent => :default) do
  confine :kernel => [:linux]
  defaultfor :kernel => [:linux]

  commands :gpasswd => '/usr/bin/gpasswd'

  def members=(value)
    gpasswd(['-M', resource[:members].join(',')])
  end
end
