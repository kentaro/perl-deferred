use strict;
use warnings;

use Test::More;
use Test::Name::FromLine;

use Deferred::Queue;

subtest 'dispatch callbacks' => sub {
    my @stash;

    my $cb1 = sub { push @stash, 1 };
    my $cb2 = sub { push @stash, 2 };
    my $cb3 = sub { my $arg = shift; push @stash, "$arg 3 $arg" };

    my $deferred = Deferred::Queue->new;
    $deferred->done($cb1, $cb2, $cb3, $cb2, $cb1)
             ->done(sub { my $arg = shift; push @stash, "$arg we're done." });

    ok !$deferred->is_cancelled;
    ok !$deferred->is_resolved;
    is scalar @{$deferred->callbacks}, 6;

    $deferred->resolve('and');

    is join(' ', @stash), q{1 2 and 3 and 2 1 and we're done.};
    ok !$deferred->is_cancelled;
    ok $deferred->is_resolved;
    is scalar @{$deferred->callbacks}, 0;
};

subtest 'cancell callbacks' => sub {
    my @stash;

    my $cb1 = sub { push @stash, 1 };
    my $cb2 = sub { push @stash, 2 };

    my $deferred = Deferred::Queue->new;
    $deferred->done($cb1, $cb2);

    ok !$deferred->is_cancelled;
    is scalar @{$deferred->callbacks}, 2;

    $deferred->cancel;

    ok $deferred->is_cancelled;
    is scalar @{$deferred->callbacks}, 0;

    $deferred->resolve('and');

    is join(' ', @stash), '';
};

done_testing;
