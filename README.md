# knife OPC #

* Documentation: http://docs.opscode.com/
* Tickets/Issues: http://tickets.opscode.com
* IRC: [#chef](irc://irc.freenode.net/chef) and [#chef-hacking](irc://irc.freenode.net/chef-hacking) on Freenode
* Mailing list: http://lists.opscode.com

# Description

This knife plugin supports basic organization and user operations in
Enterprise Chef (formerly Opscode Private Chef) and Chef Server 12.

# Installation

This knife plugin is packaged as a gem.  To install it, run:

    gem install knife-opc

If you are using ChefDK, run:

    chef gem install knife-opc

## Development version

To install the latest development version:

    git clone https://github.com/opscode/knife-opc.git
    cd knife-opc
    gem build knife-opc.gemspec
    gem install knife-opc-0.3.2.gem

# Configuration

## knife.rb
Unlike other knife subcommands the subcommands in the knife-opc
plugin make API calls against the root of your OPC installations API
endpoint.

Typically the chef_server_url for your OPC installation may look like
this:

    chef_server_url https://chef.yourdomain.com/organizations/ORGNAME

To configure knife-opc, set the `chef_server_root` option to the root
of your OPC installation:

    chef_server_root https://chef.yourdomain.com/

Note that most users in an OPC installation lack the permissions to
run most of the commands from this plugin.  On Chef Server 12, the
majority of the commands provided by this plugin can be accessed via
`chef-server-ctl` wrapper commands that properly configure knife-opc
for administrative action.  We recommend you use the wrapper commands
whenever possible

When using knife-opc directly, many of the commands require special
permissions. For instance, in order to use commands such as `knife opc
org create`, you must authenticate as the 'pivotal' user.

Note that the key for the pivotal user is in /etc/opscode on any node
in your Chef Server cluster.  We recommend that you only use the
pivotal user from a Chef Server itself and not copy this key off the
machine. In that case, you should run knife opc on the **Frontend
server** as root, with a `knife.rb` in root's home directory.

    current_dir = File.dirname(__FILE__)
    log_level                :info
    log_location             STDOUT
    node_name                "pivotal"
    client_key               "/etc/opscode/pivotal.pem"
    chef_server_root         "https://chef.yourdomain.com/"

# Subcommands

## knife opc user list (options)

*Options*

  * `-w`, `--with-uri`:
     Show corresponding URIs

Show a list of all users in your OPC installation.

## knife opc user show USERNAME (options)

  * `-l`, `--with-orgs`:
    Show the organizations of which the user is a member.

Shows the details of a user in your OPC installation.

## knife opc user create USERNAME FIRST_NAME [MIDDLE_NAME] LAST_NAME EMAIL PASSWORD (options)

  * `-f FILENAME`, `--filename FILENAME`:
    Write private key to FILENAME rather than STDOUT.

Creates a new user in your OPC installation.  The user's private key
will be returned in response.  Without this key, the user will need to
log into the WebUI and regenerate their key before they can use knife.

## knife opc user delete USERNAME [-d]

Deletes the given OPC user.

## knife opc user edit USERNAME

Will open $EDITOR. When finished, Knife will update the given OPC user.

## knife opc user password USERNAME [PASSWORD | --enable_external_auth]

Command for managing password and authentication for a user.

The last argument should either be a string you want the password to or you can pass --enable_external_auth instead of a password to enable external authentication for this user.

## knife opc org list

  * `-w`, `--with-uri`:
     Show corresponding URIs

  * `-a`, `--all-orgs`:
    Display hidden orgs

Show a list of all organizations in your OPC installation.

## knife opc org show ORG_NAME

Shows description of given ORG_NAME.

## knife opc org create ORG_NAME ORG_FULL_NAME

  * `-f FILENAME`, `--filename FILENAME`:
    Write private key to FILENAME rather than STDOUT.

  *  `-a USERNAME`, `--association_user USERNAME`,
    Associate USERNAME with the organization after creation.

Creates a new OPC Organization.  The private key for the organization's
validator client is returned.

## knife opc org delete ORG_NAME

Deletes the given OPC organization.

## knife opc org user add ORGNAME USERNAME

Adds a user to an organization.  Requires that the named organization
and user both exist.

## knife opc org user remove ORGNAME USERNAME

Removes a user from an organization.  Requires that the named
organization and user both exist, and that the user is currently
associated with the organization.

# KNOWN ISSUES

* Attempting to delete and immediately recreate an organization will
  result in an error (a 500 or a 409 Conflict depending on the server
  version). This is because of a server-side cache that must be
  cleared. Restarting the frontend services before recreating the org
  is necessary to avoid the error.

# TODO

* `--with-users` option for `org show` subcommand.

## License ##

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Copyright:**       | Copyright (c) 2011-2014 Opscode, Inc.
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
