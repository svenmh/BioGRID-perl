package BioGRID;
use strict;
use warnings;
use Data::Dumper;

use BioGRID::_node;
use BioGRID::_edge;

sub new{
    my $c=shift;
    my $s=
      {edge=>{},node=>{}};
    return bless $s,$c;
};

sub add_interactor{ # node
    my $s=shift;
    my $i=shift;

    if(exists $s->{node}->{$i->unique()}){
	# we already have this node
	return $s->{node}->{$i->unique()};
    }
    $s->{node}->{$i->unique()}=$i;
    return $i;
}

sub add_interaction{ # edge
    my $s=shift;
    my $i=shift;

    if(exists $s->{edge}->{$i->unique()}){
	# we already have that edge
	return $s->{edge}->{$i->unique()};
    }

    # if we already have a node we want to use the existing one
    $i->{node_a}=$s->add_interactor($i->interactor_a());
    $i->{node_b}=$s->add_interactor($i->interactor_b());

    $s->{edge}->{$i->unique()}=$i;
    return $i;
}

# returns the number of interactions
sub interaction_count{
    my $s=shift;
    return scalar(keys %{$s->{edge}});
}

# returns the number of interactors
sub interactor_count{
    my $s=shift;
    return scalar(keys %{$s->{node}});
}

sub nodes_edge_count{
    my $s=shift;
    my $m=shift; # match hash
    my %c; # node->unique() => count edges node is in

    for(values %{$s->{edge}}){
	my $a=$_->interactor_a();
	my $b=$_->interactor_b();

	$c{$a->unique()}++ if(!$m or $a->match_all($m));
	$c{$b->unique()}++ if(!$m or $b->match_all($m));
    }

#    warn 'foo ',$m,' ',Dumper \%c;
    return \%c;
}


sub nodes_edge_count_report{
    my $s=shift;
    my $t=$s->nodes_edge_count(shift);

   my $out='';
    while(my ($id,$c)=each %$t){
	$out .= $s->{node}->{$id}->human() . ":$c\n";
    }

    return $out;
}

return 1;
