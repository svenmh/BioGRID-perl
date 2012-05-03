# -*- cperl -*-

use strict;
use warnings;
use Cwd qw/abs_path/;
use Data::Dumper;

use BioGRID::TAB2;

print "1..5\nok\n";

my $bg=BioGRID::TAB2::file('t/yeast.tab2.txt');

print ('BioGRID' eq ref($bg)?"ok\n":"not ok\n");
print ((3==$bg->interaction_count())?"ok\n":"not ok\n");

my $n=$bg->interactor(34518);
print ('BioGRID::_node' eq ref($n)?"ok\n":"not ok\n");
print (("LEO1\t559292\t2\t1" eq $bg->report($n))?"ok/n":"not ok/n");
