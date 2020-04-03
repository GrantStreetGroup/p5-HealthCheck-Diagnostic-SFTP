package HealthCheck::Diagnostic::SFTP;
use parent 'HealthCheck::Diagnostic';

# ABSTRACT: Check for SFTP access and operations in a HealthCheck
# VERSION

use strict;
use warnings;

use Carp;
use Net::SFTP;

# For some reason, without this in the cpanfile
# Net::SFTP wouldn't install, so leave this note.
require Net::SSH::Perl::Buffer;

sub new {
    my ($class, @params) = @_;

    my %params = @params == 1 && ( ref $params[0] || '' ) eq 'HASH'
        ? %{ $params[0] } : @params;

    return $class->SUPER::new(
        id    => 'sftp',
        label => 'sftp',
        %params,
    );
}

sub check {
    my ($self, %params) = @_;

    # Allow the diagnostic to be called as a class as well.
    if ( ref $self ) {
        $params{$_} = $self->{$_}
            foreach grep { ! defined $params{$_} } keys %$self;
    }

    # The host is the only required parameter.
    croak "No host" unless $params{host};

    return $self->SUPER::check(%params);
}

sub run {
    my ($self, %params) = @_;
    my $host     = $params{host};
    my $callback = $params{callback};

    # Get our description of the connection.
    my $user        = $params{user};
    my $name        = $params{name};
    my $target      = ( $user ? $user.'@' : '' ).$host;
    my $description = $name ? "$name ($target) SFTP" : "$target SFTP";

    # Try to connect to the host.
    my $sftp;
    my %args = map { $_ => $params{$_} }
        grep { exists $params{$_} }
        qw( user password debug warn ssh_args );
    local $@;
    eval {
        local $SIG{__DIE__};
        $sftp = Net::SFTP->new( $host, %args );
    };
    return {
        status => 'CRITICAL',
        info   => "Error for $description: $@",
    } if $@;

    # No errors were returned so it must be a successful result,
    # unless we want to run a callback.
    return {
        status => 'OK',
        info   => "Successful connection for $description",
    } unless $callback;

    # Try to run a callback on the instance if one is provided.
    my $result;
    eval {
        local $SIG{__DIE__};
        $result = $callback->( $sftp );
    };
    return {
        status => 'CRITICAL',
        info   => "Error in running callback for $description: $@",
    } if $@;

    # Return the callback result hash, or a generic success message.
    return ref $result eq 'HASH' ? $result : {
        status => 'OK',
        info   => "Successful connection and callback for $description",
    };
}

1;
__END__

=head1 SYNOPSIS

    use HealthCheck::Diagnostic::SFTP;

    # Just check that we can connect to a host.
    HealthCheck::Diagnostic::SFTP->check(
        host => 'sftp.example.com',
        user => 'auser',
    );

    # Check that the './history' file exists on the host.
    HealthCheck::Diagnostic::SFTP->check(
        host     => 'sftp.example.com',
        callback => sub {
            my ($sftp)      = @_;
            my ($directory) = @{ $sftp->ls('history') || [] };
            return {
                info   => 'Looking for "history" file.',
                status => $directory ? 'OK' : 'CRITCAL',
            };
        },
    );

=head1 DESCRIPTION

This diagnostic allows a process to test SFTP connectivity to a server.
You can specify the host and additional parameters and the rest is
handled by the diagnostic.
Additionally, you can send in a callback to run after connecting for more
checks.

=head1 ATTRIBUTES

=head2 name

A descriptive name for the connection test.
This gets populated in the resulting C<info> tag.

=head2 host

The server name to connect to for the test.
This is required.

=head2 callback

An anonymous sub that can get run after a conneciton is made to the
host. This sub receives one argument, the L<Net::SFTP> instance that
was recently created.

=head2 user

Optional argument that can get passed into the L<Net::SFTP> constructor.
Represents the authentication user credential for the host.

=head2 password

Optional argument that can get passed into the L<Net::SFTP> constructor.
Represents the authentication password credential for the host.

=head2 debug

Optional argument that can get passed into the L<Net::SFTP> constructor.
Represents whether to print debug information or not.

=head2 warn

Optional argument that can get passed into the L<Net::SFTP> constructor.
An anonymous sub that gets called when warnings are generated.

=head2 ssh_args

Optional argument that can get passed into the L<Net::SFTP> constructor.
Additional SSH connection arguments.

=head1 DEPENDENCIES

L<Net::SFTP>
L<HealthCheck::Diagnostic>

=head1 CONFIGURATION AND ENVIRONMENT

None
