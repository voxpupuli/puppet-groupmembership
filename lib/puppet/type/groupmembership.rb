Puppet::Type.newtype(:groupmembership) do
  @doc = "Manage a POSIX group's members"

  autorequire(:group) do
    self[:name]
  end

  newparam :name, :namevar => true

  newparam(:exclusive) do
    defaultto :false
    newvalues(:true, :false)
  end

  newproperty(:members, :array_matching => :all) do
  end

end
