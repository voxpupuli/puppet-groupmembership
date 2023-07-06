# Groupmembership

[![Build Status](https://github.com/voxpupuli/puppet-groupmembership/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-groupmembership/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-groupmembership/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-groupmembership/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/groupmembership.svg)](https://forge.puppetlabs.com/puppet/groupmembership)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/groupmembership.svg)](https://forge.puppetlabs.com/puppet/groupmembership)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/groupmembership.svg)](https://forge.puppetlabs.com/puppet/groupmembership)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/groupmembership.svg)](https://forge.puppetlabs.com/puppet/groupmembership)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-groupmembership)
[![Apache-2.0](https://img.shields.io/github/license/voxpupuli/puppet-groupmembership.svg)](LICENSE)

A simple type to manage the membership of a group, from the perspective of the group.

It is worth noting, if you are using this model of membership, you should not
be using the `groups` parameter on the user type.

```Puppet
groupmembership { 'trees':
  members => ['oak','elm']
}
```

Pretty easy, right?

There is also an `exclusive` option to ensure that the only members of a group
are those that have been expressed as part of the members parameter.

## Requirements

On OSX, you will need the `plist` gem.

