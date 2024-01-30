Puppet::Type.type(:groupmembership).provide(:dscl) do
  desc "Manage a POSIX group's membership"

  confine kernel: [:darwin]
  defaultfor kernel: [:darwin]

  def members
    member_list = dscl_group_data['dsAttrTypeStandard:GroupMembership'].sort

    Puppet.debug("Current membership for #{resource[:name]} is #{member_list}")
    member_list
  end

  def dscl_group_data
    output = execute(
      [
        '/usr/bin/dscl',
        '-plist',
        '.',
        '-read',
        "/Groups/#{resource[:name]}"
      ],
      failonfail: false,
      combine: true
    )
    self.class.parse_plist(output)
  end

  def members=(value)
    current_members = members
    Puppet.debug("Setting membership on #{resource[:name]} to #{value}")
    if resource[:exclusive]
      current_members.each do |username|
        next if value.include? username

        execute(
          [
            '/usr/bin/dscl',
            '.',
            '-delete',
            "/Groups/#{resource[:name]}",
            'GroupMembership',
            username
          ],
          failonfail: false
        )
      end
    end

    value.each do |username|
      next if current_members.include? username

      execute(
        [
          '/usr/bin/dscl',
          '.',
          '-append',
          "/Groups/#{resource[:name]}",
          'GroupMembership',
          username
        ],
        failonfail: false
      )
    end
  end

  def self.parse_plist(xml_data)
    require 'plist'
    Plist.parse_xml(xml_data)
  end
end
