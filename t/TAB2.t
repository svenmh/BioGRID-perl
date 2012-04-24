# -*- perl -*-

use strict;
use warnings;
use Cwd qw/abs_path/;
use Data::Dumper;

use BioGRID::TAB2;

print "1..6\nok\n";

my $bg=BioGRID::TAB2::file('t/yeast.tab2.txt');

print $bg?"ok\n":"not ok\n";
print ((2==$bg->interaction_count())?"ok\n":"not ok\n");
print ((2==$bg->interactor_count())?"ok\n":"not ok\n");

my $r=$bg->nodes_edge_count({organism=>559292});
print ((2==$r->{34272})?"ok\n":"not ok\n");
print ((2==$r->{31676})?"ok\n":"not ok\n");
