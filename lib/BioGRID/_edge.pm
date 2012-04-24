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



return 1;
