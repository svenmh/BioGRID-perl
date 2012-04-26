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

=item $interaction->contains_interactors(@interactors)

Returns itself if C<$interaction> interactors are both is the
C<@interactors> list.  Otherwise returns C<undef>.

=cut
sub contains_interactors{
    my $e=shift;
    my @n=@_;

    my $have_a=undef;
    my $have_b=undef;

    my $id_a=$e->interactor_a()->unique();
    my $id_b=$e->interactor_b()->unique();

    for my $n(@n){
	my $id_n=$n->unique();

	$have_a=$n if(!$a && ($id_a==$id_n));
	$have_b=$n if(!$b && ($id_b==$id_n));
	return $e if($have_a && $have_b);
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
