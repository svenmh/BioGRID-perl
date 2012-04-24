package BioGRID::TAB2;
use strict;
use warnings;
use Data::Dumper;

use BioGRID;

sub _node{
    my $o=shift; # 0 or 1
    return new BioGRID::_node
      (
       {
	entrez_gene=>$_[1+$o],
	biogrid_id=>$_[3+$o],
	systematic_name=>$_[5+$o],
	official_symbol=>$_[7+$o],
	synonyms=>$_[9+$o],
	organism=>$_[15+$o],
       }
      );
}

# see http://wiki.thebiogrid.org/doku.php/biogrid_tab_version_2.0
sub line{
    my $i=new BioGRID::_edge
      (
       {
	node_a=>_node(0,@_),
	node_b=>_node(1,@_),
	biogrid_interaction_id=>$_[0],
	experimental_system=>$_[11],
	experimental_system_type=>$_[12],
	author=>$_[13],
	pubmed_id=>$_[14],
	throughput=>$_[17],
	score=>$_[18],
	modification=>$_[19],
	phenotypes=>$_[20],
	qualifications=>$_[21],
	tags=>$_[22],
	source_database=>$_[23],
       }
      );
    return $i;
}

sub file{
    my $f=shift;
    my $h;

    if(!open($h,$f)){
	warn "Can't open $f, $!";
	return 0;
    }

    my $bg=new BioGRID();
    while(<$h>){
	chomp;
	next if(m/^#/);
	$bg->add_interaction(line(split(m/\t/)));
    }

    close($h);
    return $bg;
}

return 1;
