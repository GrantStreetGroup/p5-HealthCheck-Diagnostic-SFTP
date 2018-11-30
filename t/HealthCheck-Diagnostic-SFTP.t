use strict;
use warnings;

use Test::More;
use Test::Differences;
use HealthCheck::Diagnostic::SFTP;

# Check that we can use HealthCheck as a class.
{
    my $result = HealthCheck::Diagnostic::SFTP->check(
        host => 'good-host',
    );
    is $result->{status}, 'OK',
        'Can use HealthCheck as a class.';
    is $result->{info}, 'Successful connection for good-host SFTP',
        'Info message is correct for instance check.';
}

# Check that we can use HealthCheck with initialized values too.
{
    my $diagnostic = HealthCheck::Diagnostic::SFTP->new(
        host => 'good-host',
    );
    my $result = $diagnostic->check;
    is $result->{status}, 'OK',
        'Can use HealthCheck with instance values too.';
    is $result->{info}, 'Successful connection for good-host SFTP',
        'Info message is correct for initialized diagnostic.';
}

# Check that `check` parameters override the initialized parameters.
{
    my $diagnostic = HealthCheck::Diagnostic::SFTP->new(
        host => 'good-host1',
    );
    my $result = $diagnostic->check( host => 'good-host2' );
    is $result->{status}, 'OK',
        'HealthCheck result status is still OK.';
    is $result->{info}, 'Successful connection for good-host2 SFTP',
        'Info message shows that the `check` host overrides all.';
}

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

# Check that we require the host, but the other parameters
# can be passed in as optional parameters.
{
    my %default = ( host => 'good-host' );
    like $run_check_or_error->(), qr/No host/,
        'Cannot run check without host.';
    eq_or_diff( $run_check_or_error->( %default ),
        [ 'OK', 'Successful connection for good-host SFTP' ],
        'Can run check with only host.' );

    eq_or_diff( $run_check_or_error->( %default, user => 'us' ),
        [ 'OK', 'Successful connection for us@good-host SFTP' ],
        'Can run check with only host and user.' );
}

# Check that the description is correctly displayed with the supplied
# parameters.
{
    is $run_check_or_error->(
        host => 'good-host',
    )->[1], 'Successful connection for good-host SFTP',
        'Host is in description when specified.';
    is $run_check_or_error->(
        host => 'good-host',
        user => 'user',
    )->[1], 'Successful connection for user@good-host SFTP',
        'Host and user is in the description when specified.';
    is $run_check_or_error->(
        host => 'good-host',
        user => 'user',
        name => 'Type1',
    )->[1], 'Successful connection for Type1 (user@good-host) SFTP',
        'Host, user, and name are in the description when specified.';
    is $run_check_or_error->(
        host => 'good-host',
        name => 'Type2',
    )->[1], 'Successful connection for Type2 (good-host) SFTP',
        'Host and name are in the description when specified.';
}

done_testing;
