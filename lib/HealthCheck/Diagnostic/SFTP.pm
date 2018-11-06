package HealthCheck::Diagnostic::SFTP;
use parent 'HealthCheck::Diagnostic';

# ABSTRACT: Check for SFTP access and operations in a HealthCheck
# VERSION

use strict;
use warnings;

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

1;
__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 DEPENDENCIES

L<HealthCheck::Diagnostic>

=head1 CONFIGURATION AND ENVIRONMENT

None
