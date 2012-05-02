package BioGRID::TAB2;
use strict;
use warnings;
use Data::Dumper;

use BioGRID;

=head1 NAME

BioGRID::TAB2 - Reads BioGRID TAB2 data and returns a L<BioGRID> object

=head1 SYNOPSIS

 use BioGRID::TAB2;
 my $bg=BioGRID::TAB2::file('rest.tab2.txt');
 $bg->report_all();

=head1 METHODS

=over

=cut
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

=item BioGRID::TAB2::line(@row)

C<@row> is a singe TAB2 line split on the tab character.  Returns an
L<BioGRID::_edge> object.

=cut
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

=item BioGRID::TAB2::file($path)

C<$path> is a path to a TAB2 file.  This loads this file into memory
and returns a L<BioGRID> object with all the data.

=cut
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

=back

=head1 SEE ALSO

L<BioGRID>, L<BioGRID TAB 2.0 Formatted
Downloads|http://wiki.thebiogrid.org/doku.php/biogrid_tab_version_2.0>
L<GitHub|https://github.com/svenmh/BioGRID-perl>, and
L<BioGRID|http://thebiogrid.org/>


=head1 COPYRIGHT

Copyright 2012 The Trustees of Princeton University

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
