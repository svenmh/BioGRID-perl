package BioGRID::_edge;
use strict;
use warnings;
use Data::Dumper;

sub new{
    my $c=shift;
    my $s=shift;
    return bless $s,$c;
}

sub unique{
    my $s=shift;
    return $s->{biogrid_interaction_id};
}

sub interactor_a{
    my $s=shift;
    return $s->{node_a};
}
sub interactor_b{
    my $s=shift;
    return $s->{node_b};
}

sub contains_interactor{
    my $s=shift;
    my $n=shift;

    if(($n->unique() eq $s->interactor_a()->unique()) ||
       ($n->unique() eq $s->interactor_b()->unique()) ){
	return $s;
    }

    return undef;
}

sub contains_any_interactors{
    my $s=shift;
    my @n=@_;

    for my $n(@n){
	return $n if($s->contains_interactor($n));
    }
    return undef;
}

sub contains_any2_interactors{
    my $s=shift;
    my @n=@_;

    my $have=$s->contains_any_interactors(@n);
    if($have){
	my $hid=$have->unique();
	for my $n(@n){
	    next if($n->unique()==$hid);
	    return $s if($s->contains_interactor($n));
	}
    }

    return undef;
}

sub other_interactor{
    my $s=shift;
    my $i=shift;
    warn 'hello! ',$i if(!$i);
    my $u=$i->unique();


    if($u eq $s->interactor_a()->unique()){
	return $s->interactor_b();
    }

    if($u eq $s->interactor_b()->unique()){
	return $s->interactor_a();
    }
}

return 1;
