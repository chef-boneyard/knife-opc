# knife OPC

# Description

This knife plugin supports basic organization and user operations in
Enterprise Chef (formerly Opscode Private Chef).

# Installation

This knife plugin is packaged as a gem.  To install it, clone the
git repository and run the following:

    gem build knife-opc.gemspec
    gem install knife-opc-0.0.1.gem

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
run most of the commands from this plugin.

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

Deletes the given OPC user.

# TODO

* `--with-users` option for `org show` subcommand.
* Filter unused fields from `org show`.
