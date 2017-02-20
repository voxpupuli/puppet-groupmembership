Puppet::Type.type(:groupmembership).provide(:openbsd, parent: :getent) do
  desc "Manage a POSIX group's membership"

  confine kernel: :openbsd
  defaultfor kernel: :openbsd

  def members=(value)
    f = getent_group.split(':', 4)
    f.size > 3 && f.pop

    grouplist_prefix = f.join(':').chomp
    member_list = Array(value).sort.join(',')
    replacement = [grouplist_prefix, member_list].join(':')
    Puppet.debug("Setting membership on #{resource[:name]} to #{member_list}")

    if resource[:exclusive] == :true
      execute(
        [
          '/usr/bin/sed',
          '-i.new',
          '-e',
          "s/#{resource[:name]}.*/#{replacement}/",
          '/etc/group'
        ]
      )
    else
      require 'pp'
      current_members = members
      Array(value).each do |member|
        next if current_members.include? member
        execute(
          [
            '/usr/sbin/usermod',
            '-G',
            resource[:name],
            member
          ],
          failonfail: false
        )
      end
    end
  end
end
