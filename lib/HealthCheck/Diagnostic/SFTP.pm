package HealthCheck::Diagnostic::SFTP;
use parent 'HealthCheck::Diagnostic';

# ABSTRACT: Check for SFTP access and operations in a HealthCheck
# VERSION

use strict;
use warnings;

use Carp;

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
    # The host is the only required parameter.
    croak "No host" unless $params{host};

    return $self->SUPER::check(%params);
}

sub run {
    my ($self, %params) = @_;
    my $host     = $params{host};

    # Get our description of the connection.
    my $description = "$host SFTP";

    return {
        status => 'OK',
        info   => "Successful connection for $description",
    };
}

1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

This diagnostic allows a process to test SFTP connectivity to a server.
You can specify the host and the rest is handled by the diagnostic.

=head1 ATTRIBUTES

=head2 host

The server name to connect to for the test.
This is required.

=head1 DEPENDENCIES

L<HealthCheck::Diagnostic>

=head1 CONFIGURATION AND ENVIRONMENT

None
