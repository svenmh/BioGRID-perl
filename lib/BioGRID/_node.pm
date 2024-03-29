package BioGRID::_node;
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
    return $s->{biogrid_id};
}

sub organism_id{
    my $s=shift;
    return $s->{organism};
}

# return human readable rep
sub human{
    my $s=shift;
    return $s->{official_symbol};
}

sub match_all{
    my $s=shift;
    my $m=shift; # hash
    my $out=0;

    for(keys %$m){
	$out++ if($m->{$_} eq $s->{$_});
    }
    return $out;
}

return 1;
