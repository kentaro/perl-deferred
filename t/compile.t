use strict;
use Test::More tests => 1;

BEGIN {
    use_ok $_ for qw(
        Deferred
        Deferred::Queue
    );
}
