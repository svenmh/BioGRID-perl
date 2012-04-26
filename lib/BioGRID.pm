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

=item $bg->interactors()

Returns a list of all interactor objects (See L<BioGRID::_node>).

=cut
sub interactors{
    my $bg=shift;
    return values %{$bg->{node}};
}

=item $bg->interactions([@interactors])

With no arguments returns a list of all interactions (See
L<BioGRID::_edge>).

Otherwise will return a list of interactors whos interactions are in
C<@interactors>.

=cut
sub interactions{
    my $bg=shift;
    my @n=@_;

    return values %{$bg->{edge}} if(0==scalar @n);

    # if we more have arguments, assume they are nodes, and return all
    # edges both nodes frome it the list.
    my @e;
    for my $e($bg->interactions()){
	if($e->contains_interactors(@n)){
	    push @e,$e;
	}
    }
    return @e;
}

=over $bg->connected_interactors($interaction)

Returns a list of interactions that are connected to C<$interaction>.

=cut
sub connected_interactors{
    my $bg=shift;
    my $n=shift;
    my %n;

    for my $e($bg->interactions()){
	my $o=$e->other_interactor($n);
	if($o){
	    $n{$o->unique()}=$o;
	}
    }
    return values %n;
}

=item $bg->interactor($interactor)

If C<$interaction> is a object it passes it through.  Otherwise it
assumes it's a BioGRID interactor id and will to to return the
interactor object.

=cut
sub interactor{
    my $bg=shift;
    my $n=shift;

    return ('' eq ref $n)?$bg->{node}->{$n}:$n;
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

=item $bg->report($interactor)

C<$interocator> is either interactor object or an interactor BioGRID
identifier.

Returns a tab seporated list of three items related to C<$interactor>.

=over

=item Readable protein name

=item Number of interactors with this protein

=item Plus number of interactor interactions

=back

=cut
sub report{
    my $bg=shift;
    my $n=$bg->interactor(shift);

    my @n=$bg->connected_interactors($n);
    unshift(@n,$n);
    my @e=$bg->interactions(@n);

    return sprintf("%s\t%d\t%d",$n->human(),scalar(@n),scalar(@e));
}

sub report_all{
    my $s=shift;
    local $|=1;

    print "#protein\tinteractors\tinteractor interactions\n";
    for my $n($s->interactors()){
	print $s->report($n) . "\n";
    }
}

return 1;
