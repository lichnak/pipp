
=head1 TITLE

Object - Pipp Object class

=head1 DESCRIPTION

This file sets up the base classes and methods for Pipp's
object system.  Differences (and conflicts) between Parrot's
object model and the PHP model means we have to do a little
name and method trickery here and there, and this file takes
care of much of that.

This is heavily based on Rakudo's Object.pir

=cut

.namespace ['PippObject']

=head2 Methods

=over 4

=item defined()

Return true if the object is defined.
Default to being defined.

=cut

.namespace ['PippObject']
.sub 'defined' :method
    $P0 = new 'PhpBoolean'
    $P0 = 1

    .return ($P0)
.end

=item true()

Boolean value of object -- defaults to C<.defined> (S02).

=cut

.namespace ['PippObject']
.sub 'true' :method
    .tailcall self.'defined'()
.end

=item WHENCE()

Return the invocant's auto-vivification closure.

=cut

.sub 'WHENCE' :method
    $P0 = self.'WHAT'()
    $P1 = $P0.'WHENCE'()
    .return ($P1)
.end

=item __construct

A default constructor. Used for checking that there are no args.
See BUILD in Rakudo.

=cut

.sub '__construct' :method
    .local pmc p6meta, parrotclass, attributes, it
    p6meta = get_hll_global ['PippObject'], '$!P6META'
    parrotclass = p6meta.'get_parrotclass'(self)
    attributes = inspect parrotclass, 'attributes'
    it = iter attributes
  attrinit_loop:
    unless it goto attrinit_done
    .local string attrname, keyname
    .local pmc attr, attrhash
    attrname = shift it
    attr = getattribute self, parrotclass, attrname
    attrhash = attributes[attrname]
    $P0 = attrhash['init_value']
    if null $P0 goto attrinit_loop
    $P0 = $P0(self, attr)
    # $P77 = get_root_global ['parrot'], '_dumper'
    # $P77( $P0, 'returned from init_value')
    setattribute self, parrotclass, attrname, $P0
    goto attrinit_loop
  attrinit_done:
    .return (self)
.end

=back

=head2 Private methods

=over 4

=back

=head2 Vtable functions

=cut

.namespace ['PippObject']

.sub '' :vtable('get_bool') :method
    $I0 = self.'true'()
    .return ($I0)
.end


# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
