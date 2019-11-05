# NAME

HealthCheck::Diagnostic::SFTP - Check for SFTP access and operations in a HealthCheck

# VERSION

version 1.2.0.1

# SYNOPSIS

    use HealthCheck::Diagnostic::SFTP;

    # Just check that we can connect to a host.
    HealthCheck::Diagnostic::SFTP->check(
        host => 'appws003-test3',
        user => 'dveres',
    );

    # Check that the './history' file exists on the host.
    HealthCheck::Diagnostic::SFTP->check(
        host     => 'appws003-test3',
        callback => sub {
            my ($sftp)      = @_;
            my ($directory) = @{ $sftp->ls('history') || [] };
            return {
                info   => 'Looking for "history" file.',
                status => $directory ? 'OK' : 'CRITCAL',
            };
        },
    );

# DESCRIPTION

This diagnostic allows a process to test SFTP connectivity to a server.
You can specify the host and additional parameters and the rest is
handled by the diagnostic.
Additionally, you can send in a callback to run after connecting for more
checks.

# ATTRIBUTES

## name

A descriptive name for the connection test.
This gets populated in the resulting `info` tag.

## host

The server name to connect to for the test.
This is required.

## callback

An anonymous sub that can get run after a conneciton is made to the
host. This sub receives one argument, the [Net::SFTP](https://metacpan.org/pod/Net%3A%3ASFTP) instance that
was recently created.

## user

Optional argument that can get passed into the [Net::SFTP](https://metacpan.org/pod/Net%3A%3ASFTP) constructor.
Represents the authentication user credential for the host.

## password

Optional argument that can get passed into the [Net::SFTP](https://metacpan.org/pod/Net%3A%3ASFTP) constructor.
Represents the authentication password credential for the host.

## debug

Optional argument that can get passed into the [Net::SFTP](https://metacpan.org/pod/Net%3A%3ASFTP) constructor.
Represents whether to print debug information or not.

## warn

Optional argument that can get passed into the [Net::SFTP](https://metacpan.org/pod/Net%3A%3ASFTP) constructor.
An anonymous sub that gets called when warnings are generated.

## ssh\_args

Optional argument that can get passed into the [Net::SFTP](https://metacpan.org/pod/Net%3A%3ASFTP) constructor.
Additional SSH connection arguments.

# DEPENDENCIES

[Net::SFTP](https://metacpan.org/pod/Net%3A%3ASFTP)
[HealthCheck::Diagnostic](https://metacpan.org/pod/HealthCheck%3A%3ADiagnostic)

# CONFIGURATION AND ENVIRONMENT

None

# AUTHOR

Grant Street Group <developers@grantstreet.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2018 - 2019 by Grant Street Group.  No
license is granted to other entities.

# CONTRIBUTORS

- Authors:
- (9) Brandon Messineo <brandon.messineo@grantstreet.com>
- (2) Andrew Hewus Fresh <andrew.fresh@grantstreet.com>
- Reviewers:
- (1) Andrew Fresh <andrew.fresh@grantstreet.com> 
- (1) Brandon Messineo <brandon.messineo@grantstreet.com> 
- Deployers:
- (6) Brandon Messineo <brandon.messineo@grantstreet.com>  
