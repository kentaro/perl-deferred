use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::ReadmeMarkdownFromPod;

name 'Deferred';
all_from 'lib/Deferred.pm';
readme_markdown_from 'lib/Deferred.pm';

requires 'Coro';
requires 'parent';
requires 'Try::Tiny';
requires 'Class::Accessor::Lite';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More' => 0.96;
test_requires 'Test::Name::FromLine';
author_tests('xt');

WriteAll;
