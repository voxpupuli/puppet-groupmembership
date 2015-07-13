Puppet::Type.type(:groupmembership).provide(:pw, :parent => :default) do
  confine :kernel => [:freebsd]
  defaultfor :kernel => [:freebsd]

  commands :pw => '/usr/sbin/pw'

  def members=(value)
    p(['-M', resource[:members].join(',')])
  end
end

