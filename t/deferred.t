use strict;
use warnings;

use Test::More;
use Test::Name::FromLine;

use Coro;
use Coro::AnyEvent;
use Deferred;

subtest 'passing a callback into constructor' => sub {
    my $deferred = deferred(
        sub {
            my $deferred = shift;
            Coro::AnyEvent::sleep 1;
            $deferred->resolve('-');
        }
    );

    $deferred->done(
        sub { my $arg = shift; warn "$arg foo"; },
        sub { my $arg = shift; warn "$arg bar"; },
    );
};

done_testing;
