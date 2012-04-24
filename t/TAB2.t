# -*- perl -*-

use strict;
use warnings;
use Cwd qw/abs_path/;
use Data::Dumper;

use BioGRID::TAB2;

print "1..4\nok\n";

my $bg=BioGRID::TAB2::file('t/yeast.tab2.txt');

if($bg){
    print "ok\n";
}else{
    print "not ok\n";
}

if(2==$bg->interaction_count()){
    print "ok\n";
}else{
    print "not ok\n";
}

if(2==$bg->interactor_count()){
    print "ok\n";
}else{
    print "not ok\n";
}

warn $bg->node_report({organism=>559292});
#warn Dumper $bg;
