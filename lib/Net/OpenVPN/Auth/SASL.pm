# Copyright (c) 2006, Brane F. Gracnar
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# + Redistributions of source code must retain the above copyright notice,
#  this list of conditions and the following disclaimer.
#
# + Redistributions in binary form must reproduce the above copyright notice,
#  this list of conditions and the following disclaimer in the documentation
#  and/or other materials provided with the distribution.
#
# + Neither the name of the Brane F. Gracnar nor the names of its contributors
#   may be used to endorse or promote products derived from this software without
#   specific prior written permission.
#
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# $Id$
# $LastChangedRevision$
# $LastChangedBy$
# $LastChangedDate$

package Net::OpenVPN::Auth::SASL;

@ISA = qw(Net::OpenVPN::Auth);

use strict;
use warnings;

use Log::Log4perl;
use Authen::SASL qw(Cyrus);

=head1 NAME SASL

Simple authentication and security layer (SASL) authentication backend module,
able to authenticate using cyrus-sasl native library. You need Authen::SASL::Cyrus
perl module installed in order to use this module. 

=head1 OBJECT CONSTRUCTOR

=head2 Inherited parameters

B<required> (boolean, 1) successfull authentication result is required for authentication chain to return successful authentication

B<sufficient> (boolean, 0) successful authentication result is sufficient for entire authentication chain 

=over

=head2 Module specific parameters

B<sasl_service> (string, "openvpn") SASL service name

=cut
sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = $class->SUPER::new(@_);

	##################################################
	#               PUBLIC VARS                      #
	##################################################

	##################################################
	#              PRIVATE VARS                      #
	##################################################
	$self->{_name} = "SASL";
	$self->{_log} = Log::Log4perl->get_logger(__PACKAGE__);
	bless($self, $class);

	# initialize object
	$self->clearParams();
	$self->setParams(@_);

	die "This driver is not yet finished.\n";

	return $self;
}

sub clearParams {
	my ($self) = @_;
	$self->SUPER::clearParams();

	$self->{sasl_service} = "openvpn";
	$self->{mechanism} = "PLAIN";

	return 1;
}

sub authenticate {
	my ($self, $struct) = @_;
	return 0 unless ($self->validateParamsStruct($struct));
	
	$self->{error} = "SASL server is currently not implemented :)";
	return 0;
 
 
 	my $sasl = Authen::SASL->new (
		mechanism => $self->{mechanism},
		callback => {
			checkpass => \&checkpass,
			canonuser => \&canonuser,
    	}
 	);

 	# creating the Authen::SASL::Cyrus object
 	my $conn = $sasl->server_new("service","","ip;port local","ip;port remote");

 	# Clients first string (maybe "", depends on mechanism)
 	# Client has to start always
 	sendreply( $conn->server_start( &getreply() ) );

	while ($conn->need_step()) {
		sendreply( $conn->server_step( &getreply() ) );
 	}

	return 1 if ($conn->code() == 0);
	return 0;
}

=head1 AUTHOR

Brane F. Gracnar, <bfg@frost.ath.cx>

=cut

=head1 SEE ALSO

L<Net::OpenVPN::Auth>
L<Net::OpenVPN::AuthChain>
L<Authen::SASL>
L<Authen::SASL::Cyrus>

=cut

1;