Puppet::Type.type(:groupmembership).provide(:getent) do
  desc "Manage a POSIX group's membership"

  confine kernel: [:linux, :freebsd, :openbsd]

  def members
    output = getent_group
    fields = output.split(':')

    member_list = if fields.size < 4
                    []
                  else
                    # group:pw:gid:u1,u2
                    fields[3].strip.split(',').reject(&:empty?).sort
                  end

    Puppet.debug("Current membership for #{resource[:name]} is #{member_list}")
    member_list
  end

  def getent_group
    execute(['/usr/bin/getent', 'group', resource[:name]], failonfail: false, combine: true)
  end
end
