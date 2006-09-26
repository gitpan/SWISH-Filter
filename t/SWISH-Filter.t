# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SWISH-Filter.t'

use Test::More tests => 3;
BEGIN { use_ok('SWISH::Filter') }

#
#   we can't test actual filtering since it relies on many other apps
#   but we can test that our modules load and look for those other apps
#

diag("running the example script");

ok(run("$^X example/swish-filter-test --quiet --noskip_binary t/test.*"), "example docs");
ok(
    run(
        "$^X example/swish-filter-test --quiet --noskip_binary --ignore XLtoHTML --ignore pp2html t/test.*"
       ),
    "example docs using catdoc"
  );

sub run
{
    diag(@_);
    system(@_) ? 0 : 1;
}
