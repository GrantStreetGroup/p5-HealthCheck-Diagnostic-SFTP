use strict;
use warnings;

use Test::More;
use Test::Differences;
use HealthCheck::Diagnostic::SFTP;

# Create a method that returns the info and status after running the
# check. If it failed, then this just returns the error.
my $run_check_or_error = sub {
    my $result;
    local $@;
    # We passed in a diagnostic, just run the check.
    if ( ref $_[0] ) {
        $result = eval { $_[0]->check } if ref $_[0] ne 'HASH';
    }
    # We passed in some check parameters, send them in.
    else {
        $result = eval {
            HealthCheck::Diagnostic::SFTP->check( @_ );
        };
    }
    return [ $result->{status}, $result->{info} ] unless $@;
    return $@;
};

# Check that we require the host.
{
    my %default = ( host => 'good-host' );
    like $run_check_or_error->(), qr/No host/,
        'Cannot run check without host.';
    eq_or_diff( $run_check_or_error->( %default ),
        [ 'OK', 'Successful connection for good-host SFTP' ],
        'Can run check with only host.' );
}

done_testing;
