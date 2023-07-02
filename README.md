# Groupmembership

[![Puppet Forge](https://img.shields.io/puppetforge/v/zleslie/groupmembership.svg)](https://forge.puppet.com/zleslie/groupmembership) [![Build Status](https://travis-ci.org/xaque208/puppet-groupmembership.svg?branch=master)](https://travis-ci.org/xaque208/puppet-groupmembership)

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

