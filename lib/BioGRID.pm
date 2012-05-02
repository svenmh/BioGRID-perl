package BioGRID;
use strict;
use warnings;
use Data::Dumper;

use BioGRID::_node;
use BioGRID::_edge;

=head1 NAME

BioGRID - Container to hold BioGRID interactions

=head1 DESCRIPTION

Not really meant to be created directly, but who knows about the
future.  Currenty see L<BioGRID::TAB2> for creating.

=head1 METHODS

=over

=item my $bg=new BioGRID( );

Create an empty BioGRID object.

=cut
sub new{
    my $c=shift;
    my $s={edge=>{},node=>{}};
    return bless $s,$c;
};

=item $bg-E<gt>add_interactor($interactor)

C<$interactor> is a L<BioGRID::_node> object.  It takes the
C<$interactor-E<gt>unique()> value and sees if it already has such an
object.  If it does it will return the value it has.  If not, it will
store it and return it.

=cut
sub add_interactor{
    my $bg=shift;
    my $n=shift;

    if(exists $bg->{node}->{$n->unique()}){
	# we already have this node
	return $bg->{node}->{$n->unique()};
    }
    $bg->{node}->{$n->unique()}=$n;
    return $n;
}

=item $bg-E<gt>add_interaction($interaction)

C<$interaction> is a L<BioGRID::_edge> object.  First it uses
C<$interaction-E<gt>unique()> to test if it already has this data.
If it does it will return the data we already have stored.

If we don't already have such an item recorded, the interactors are
passed through C<$bg-E<gt>add_interactor()> and then stores it, and
returns it.

=cut
sub add_interaction{
    my $bg=shift;
    my $e=shift; # edge

    if(exists $bg->{edge}->{$e->unique()}){
	# we already have that edge
	return $bg->{edge}->{$e->unique()};
    }

    # if we already have a node we want to use the existing one
    $e->{node_a}=$bg->add_interactor($e->interactor_a());
    $e->{node_b}=$bg->add_interactor($e->interactor_b());

    $bg->{edge}->{$e->unique()}=$e;
    return $e;
}

=item $bg-E<gt>interactors( )

Returns a list of all interactor objects (L<BioGRID::_node>).

=cut
sub interactors{
    my $bg=shift;
    return values %{$bg->{node}};
}

=item $bg-E<gt>interactions([@interactors])

With no arguments returns a list of all interactions
(L<BioGRID::_edge>).

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

=item $bg-E<gt>connected_interactors($interaction)

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

=item $bg-E<gt>interactor($interactor)

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
    my $bg=shift;
    return scalar(keys %{$bg->{edge}});
}

# returns the number of interactors
sub interactor_count{
    my $bg=shift;
    return scalar(keys %{$bg->{node}});
}

=item $bg-E<gt>report($interactor)

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

=item $bg-E<gt>report_all( )

Exectues C<$bg-E<gt>report()> on each interactor and outputs that data
is a TSV file.

=cut
sub report_all{
    my $bg=shift;
    local $|=1;

    print "#protein\tinteractors\tinteractor interactions\n";
    for my $n($bg->interactors()){
	print $bg->report($n) . "\n";
    }
}

return 1;

=back

=head1 SEE ALSO

L<BioGRID::TAB2>, L<BioGRID::_edge>, L<BioGRID::_node>,
L<GitHub|https://github.com/svenmh/BioGRID-perl>, and
L<BioGRID|http://thebiogrid.org/>


=head1 COPYRIGHT

Copyright 2012 The Trustees of Princeton University

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
