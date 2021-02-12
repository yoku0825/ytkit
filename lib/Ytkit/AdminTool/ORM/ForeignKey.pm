package Ytkit::AdminTool::ORM::ForeignKey;

########################################################################
# Copyright (C) 2021  yoku0825
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
########################################################################

use strict;
use warnings;
use utf8;

use Ytkit::Config;
use Ytkit::IO qw{ _sprintf };

my $foreignkey_option=
{
  column_name => { mandatory => 1, multi => 1 },
  reference_table => { alias => ["reference", "references", "reference_table"], mandatory => 1 },
  ### cascade means both of ON UPDATE CASCADE ON DELETE CASCADE
  action => { default => "restrict", isa => ["restrict", "cascade" ] },
  ### Now we don't support FK between other names.
};

sub new
{
  my ($class, @orig_argv)= @_;

  my $config= Ytkit::Config->new($foreignkey_option);
  $config->{_allow_extra_argv}= 0;
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}}, };
  bless $self => $class;

  ### Create index name without specification(always auto-creation)
  $self->{index_name}= _sprintf("fidx_%s", join("_", @{$self->{column_name}}));

  return $self;
}

sub new_from_row
{
  ...;
}

sub init
{
  my ($self)= @_;

  my $column_list= join(", ", map { _sprintf(q{`%s`}, $_) } @{$self->{column_name}});
  return { pre   => _sprintf(q{CONSTRAINT `%s` FOREIGN KEY `%s` (%s) REFERENCES `%s` (%s) %s},
                               $self->{index_name}, $self->{index_name}, $column_list,
                               $self->{reference_table}, $column_list,
                               $self->{action} eq "restrict" ? "ON UPDATE RESTRICT ON DELETE RESTRICT" :
                                 $self->{action} eq "cascade" ? "ON UPDATE CASCADE ON DELETE CASCADE" : ""),
           after => undef };
}

sub add
{
  my ($self)= @_;

  my $column_list= join(", ", map { _sprintf(q{`%s`}, $_) } @{$self->{column_name}});

  return { pre   => _sprintf(q{ADD CONSTRAINT `%s` FOREIGN KEY `%s` (%s) REFERENCES `%s` (%s) %s},
                               $self->{index_name}, $self->{index_name}, $column_list,
                               $self->{reference_table}, $column_list,
                               $self->{action} eq "restrict" ? "ON UPDATE RESTRICT ON DELETE RESTRICT" :
                                 $self->{action} eq "cascade" ? "ON UPDATE CASCADE ON DELETE CASCADE" : ""),
           after => undef };
}

sub drop
{
  my ($self)= @_;

  return { pre   => _sprintf(q{DROP FOREIGN KEY `%s`}, $self->{index_name}),
           after => undef };
}

sub modify
{
  my ($self)= @_;

  ### Index can't be modified, re-create.
  return { pre   => $self->drop->{pre},
           after => $self->create->{pre} };
}

return 1;