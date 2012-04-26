package BioGRID;
use strict;
use warnings;
use Data::Dumper;

use BioGRID::_node;
use BioGRID::_edge;

sub new{
    my $c=shift;
    my $s={edge=>{},node=>{}};
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

sub interactors{
    my $s=shift;
    return values %{$s->{node}};
}

sub interactions{
    my $s=shift;
    my @n=@_;

    return values %{$s->{edge}} if(0==scalar @n);

    # if we more have arguments, assume they are nodes, and return all
    # edges both nodes frome it the list.
    my @e;
    for my $e($s->interactions()){
	if($e->contains_any2_interactors(@n)){
	    push @e,$e;
	}
    }
    return @e;
}

# returns a list of nodes that connected to the given node
sub connected_interactors{
    my $s=shift;
    my $n=shift;
    my %n;

    for my $e($s->interactions()){
	my $o=$e->other_interactor($n);
	if($o){
	    $n{$o->unique()}=$o;
	}
    }
    return values %n;
}

sub interactor{
    my $s=shift;
    my $n=shift;

    return ('' eq ref $n)?$s->{node}->{$n}:$n;
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


sub report{
    my $s=shift;
    my $n=$s->interactor(shift);

    my @n=$s->connected_interactors($n);
    my @e=$s->interactions(@n);

    return sprintf("%s\t%d\t%d",$n->human(),scalar(@n),scalar(@e));
}

sub report_all{
    my $s=shift;

    local $/;
    for my $n($s->interactors()){
	warn $n->human() . "\n";
	my $got=$s->report($n) . "\n";
	warn $got;
	print $got;
    }
}

return 1;
