#!/usr/bin/perl

#########################################################################
# Copyright (C) 2017, 2018  yoku0825
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
use Test::More;

use FindBin qw{$Bin};
use lib "$Bin/../lib";
use Ytkit::Config;

open(my $spec, "<", "$Bin/../ytkit.spec");
my ($spec_version)= join("\n", <$spec>) =~ /Version:\s+([\d\.]+)/;
is($spec_version, version(), "Version number is collect");
close($spec);

subtest "Old 'options' interface" => sub
{
  subtest "options from command-line" => sub
  {
    my $option_struct=
    {
      long_with_equal            => { alias => ["long-with-equal"] },
      long_without_equal         => { alias => ["long-without-equal"] },
      long_bool                  => { alias => ["long-bool"] },
      short_with_equal           => { alias => ["E"] },
      short_without_equal        => { alias => ["N"] },
      short_bool                 => { alias => ["A"] },
      quoted_long_with_equal     => { alias => ["quoted-long-with-equal"] },
      quoted_long_without_equal  => { alias => ["quoted-long-without-equal"] },
      quoted_short_with_equal    => { alias => ["Q"] },
      quoted_short_without_equal => { alias => ["R"] },
    };
    
    my @test_argv= qw{
                        --long-with-equal=LONG_WITH_EQUAL
                        --long-without-equal LONG_WITHOUT_EQUAL
                        --long-bool
                        -E=SHORT_WITH_EQUAL
                        -N SHORT_WITHOUT_EQUAL
                        -A
                        --quoted-long-with-equal="QUOTED_LONG_WITH_EQUAL"
                        --quoted-long-without-equal "QUOTED_LONG_WITHOUT_EQUAL"
                        -Q="QUOTED_SHORT_WITH_EQUAL"
                        -R "QUOTED_SHORT_WITHOUT_EQUAL"
                        this_should_be_left_in_argv
                        this_should_be_left_in_argv_too
                     };
    
    my $expected_opt= 
    {
      long_with_equal            => "LONG_WITH_EQUAL",
      long_without_equal         => "LONG_WITHOUT_EQUAL",
      long_bool                  => 1,
      short_with_equal           => "SHORT_WITH_EQUAL",
      short_without_equal        => "SHORT_WITHOUT_EQUAL",
      short_bool                 => 1,
      quoted_long_with_equal     => "QUOTED_LONG_WITH_EQUAL",
      quoted_long_without_equal  => "QUOTED_LONG_WITHOUT_EQUAL",
      quoted_short_with_equal    => "QUOTED_SHORT_WITH_EQUAL",
      quoted_short_without_equal => "QUOTED_SHORT_WITHOUT_EQUAL",
    };
    
    my @expected_argv= qw{ this_should_be_left_in_argv this_should_be_left_in_argv_too };
    my ($got_opt, @got_argv)= options($option_struct, @test_argv);
    is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::options");
    is_deeply(\@got_argv, \@expected_argv, "ARGV by Ytkit::Config::options");
    
    done_testing;
  };
  
  subtest "options from file" => sub
  {
    my $org_opt=
    {
      should_not_erace => 1,
      duplicate_option => "from command-line option",
    };
    
    my $expected_opt= 
    {
      long_with_equal         => "LONG_WITH_EQUAL",
      long_bool               => 1,
      quoted_long_with_equal  => "QUOTED_LONG_WITH_EQUAL",
      should_not_erace        => 1,
      duplicate_option        => "from command-line option",
      singlequoted_with_space => "single quoted with space",
      doublequoted_with_space => "double quoted with space",
    };
    
    my $config_file   = "$Bin/data/03_config.txt";
    my $config_section= "ytkit_test";
    my $got_opt= load_config($org_opt, $config_file, $config_section);
    
    is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::load_config");
    
    done_testing;
  };  
  
  subtest "isa and hyphen-minus-normalization" => sub
  {
    my $option_struct=
    {
      unset_alias             => {},
      set_default             => { alias => ["set-default"], default => "this_is_default" },
      test_array_isa_fail     => { isa => [qw{test}] },
      test_array_isa_success  => { isa => [qw{test}] },
      test_regexp_isa_fail    => { isa => qr{test} },
      test_regexp_isa_success => { isa => qr{test} },
      normalize_hyphen_option => { alias => ["normalize-hyphen-option"] },
      normalize_underscore    => { alias => ["normalize_underscore"] },
      test_noarg_isa          => { alias => ["noarg"], noarg => 1 },
      test_multiple           => { alias => ["multiple"], multi => 1 },
    };
    
    my @test_argv= qw{
                        --unset_alias "parse_correctry"
                        --test_array_isa_fail="this_should_be_fail"
                        --test_array_isa_success="test"
                        --test_regexp_isa_fail="THIS_IS_FAIL_TEST"
                        --test_regexp_isa_success="this_is_success_test"
                        --noarg this_should_be_left_in_argv_because_noarg
                        --normalize_hyphen_option="ALIAS_USES_HYPHEN_BUT_OPTION_SPECIFIED_UNDERSCORE"
                        --normalize-underscore="ALIAS_USES_UNDERSCORE_BUT_OPTION_SPECIFIED_HYPHEN"
                        --multiple=a
                        --multiple=b
                        this_should_be_left_in_argv
                     };
    
    my $expected_opt= 
    {
      unset_alias             => "parse_correctry",
      set_default             => "this_is_default",
      test_array_isa_fail     => undef,
      test_array_isa_success  => "test",
      test_regexp_isa_fail    => undef,
      test_regexp_isa_success => "this_is_success_test",
      normalize_hyphen_option => "ALIAS_USES_HYPHEN_BUT_OPTION_SPECIFIED_UNDERSCORE",
      normalize_underscore    => "ALIAS_USES_UNDERSCORE_BUT_OPTION_SPECIFIED_HYPHEN",
      test_noarg_isa          => 1,
      test_multiple           => [qw{a b}],
    };
    my @expected_argv= qw{ this_should_be_left_in_argv_because_noarg this_should_be_left_in_argv };
    my ($got_opt, @got_argv)= options($option_struct, @test_argv);
    is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::options");
    is_deeply(\@got_argv, \@expected_argv, "ARGV by Ytkit::Config::options");
    
    done_testing;
  };  
  
  subtest "hash-style option" => sub
  {
    my $option_struct=
    {
      parent => { child1 => { default => "aaa" },
                  child2 => { default => "bbb" },
                  child3 => { alias => ["c"], default => "ddd" }, },
    
    };
    
    my @test_argv= qw{
                       --parent-child1="ccc"
                       this_should_be_left_in_argv
                       -c eee
                     };
    
    my $expected_opt= 
    {
      parent => { child1 => "ccc",
                  child2 => "bbb", 
                  child3 => "eee", },
    };
  
    my @expected_argv= qw{ this_should_be_left_in_argv };
    my ($got_opt, @got_argv)= options($option_struct, @test_argv);
    is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::options");
    is_deeply(\@got_argv, \@expected_argv, "ARGV by Ytkit::Config::options");
    
    done_testing;
  };
  
  subtest "test for space-including value" => sub
  {
    my $option_struct=
    {
      doublequoted_space_with_equal    => {},
      doublequoted_space_without_equal => {},
      singlequoted_space_with_equal    => {},
      singlequoted_space_without_equal => {},
    };
    
    my @test_argv= (qq{--doublequoted_space_with_equal="s p a c e 1"},
                    qq{--doublequoted_space_without_equal}, qq{"s p a c e 2"},
                    qq{--singlequoted_space_with_equal="s p a c e 3"},
                    qq{--singlequoted_space_without_equal}, qq{"s p a c e 4"},
                    "this_should_be_left_in_argv",);
    my $expected_opt= 
    {
      doublequoted_space_with_equal    => "s p a c e 1",
      doublequoted_space_without_equal => "s p a c e 2",
      singlequoted_space_with_equal    => "s p a c e 3",
      singlequoted_space_without_equal => "s p a c e 4",
    };
    
    my @expected_argv= qw{ this_should_be_left_in_argv };
    my ($got_opt, @got_argv)= options($option_struct, @test_argv);
    is_deeply($got_opt, $expected_opt, "Options by Ytkit::Config::options");
    is_deeply(\@got_argv, \@expected_argv, "ARGV by Ytkit::Config::options");
    
    done_testing;
  };
  
  done_testing;
};

subtest "new Ytkit::Config interface" => sub
{
  subtest "options from command-line" => sub
  {
    my $option_struct=
    {
      long_with_equal            => { alias => ["long-with-equal"] },
      long_without_equal         => { alias => ["long-without-equal"] },
      long_bool                  => { alias => ["long-bool"] },
      short_with_equal           => { alias => ["E"] },
      short_without_equal        => { alias => ["N"] },
      short_bool                 => { alias => ["A"] },
      quoted_long_with_equal     => { alias => ["quoted-long-with-equal"] },
      quoted_long_without_equal  => { alias => ["quoted-long-without-equal"] },
      quoted_short_with_equal    => { alias => ["Q"] },
      quoted_short_without_equal => { alias => ["R"] },
    };
    
    my @test_argv= qw{
                        --long-with-equal=LONG_WITH_EQUAL
                        --long-without-equal LONG_WITHOUT_EQUAL
                        --long-bool
                        -E=SHORT_WITH_EQUAL
                        -N SHORT_WITHOUT_EQUAL
                        -A
                        --quoted-long-with-equal="QUOTED_LONG_WITH_EQUAL"
                        --quoted-long-without-equal "QUOTED_LONG_WITHOUT_EQUAL"
                        -Q="QUOTED_SHORT_WITH_EQUAL"
                        -R "QUOTED_SHORT_WITHOUT_EQUAL"
                        this_should_be_left_in_argv
                        this_should_be_left_in_argv_too
                     };
    
    my $expected_opt= 
    {
      long_with_equal            => "LONG_WITH_EQUAL",
      long_without_equal         => "LONG_WITHOUT_EQUAL",
      long_bool                  => 1,
      short_with_equal           => "SHORT_WITH_EQUAL",
      short_without_equal        => "SHORT_WITHOUT_EQUAL",
      short_bool                 => 1,
      quoted_long_with_equal     => "QUOTED_LONG_WITH_EQUAL",
      quoted_long_without_equal  => "QUOTED_LONG_WITHOUT_EQUAL",
      quoted_short_with_equal    => "QUOTED_SHORT_WITH_EQUAL",
      quoted_short_without_equal => "QUOTED_SHORT_WITHOUT_EQUAL",
    };
    
    my @expected_argv= qw{ this_should_be_left_in_argv this_should_be_left_in_argv_too };
    my $config= Ytkit::Config->new($option_struct);
    $config->parse_argv(@test_argv);
    is_deeply($config->{result}, $expected_opt, "Options by Ytkit::Config::options");
    is_deeply($config->{left_argv}, \@expected_argv, "ARGV by Ytkit::Config::options");
    
    done_testing;
  };
  
  subtest "isa and hyphen-minus-normalization" => sub
  {
    my $option_struct=
    {
      unset_alias             => {},
      set_default             => { alias => ["set-default"], default => "this_is_default" },
      test_array_isa_fail     => { isa => [qw{test}] },
      test_array_isa_success  => { isa => [qw{test}] },
      test_regexp_isa_fail    => { isa => qr{test} },
      test_regexp_isa_success => { isa => qr{test} },
      normalize_hyphen_option => { alias => ["normalize-hyphen-option"] },
      normalize_underscore    => { alias => ["normalize_underscore"] },
      test_noarg_isa          => { alias => ["noarg"], noarg => 1 },
      test_multiple           => { alias => ["multiple"], multi => 1 },
    };
    
    my @test_argv= qw{
                        --unset_alias "parse_correctry"
                        --test_array_isa_fail="this_should_be_fail"
                        --test_array_isa_success="test"
                        --test_regexp_isa_fail="THIS_IS_FAIL_TEST"
                        --test_regexp_isa_success="this_is_success_test"
                        --noarg this_should_be_left_in_argv_because_noarg
                        --normalize_hyphen_option="ALIAS_USES_HYPHEN_BUT_OPTION_SPECIFIED_UNDERSCORE"
                        --normalize-underscore="ALIAS_USES_UNDERSCORE_BUT_OPTION_SPECIFIED_HYPHEN"
                        --multiple=a
                        --multiple=b
                        this_should_be_left_in_argv
                     };
    
    my $expected_opt= 
    {
      unset_alias             => "parse_correctry",
      set_default             => "this_is_default",
      test_array_isa_fail     => undef,
      test_array_isa_success  => "test",
      test_regexp_isa_fail    => undef,
      test_regexp_isa_success => "this_is_success_test",
      normalize_hyphen_option => "ALIAS_USES_HYPHEN_BUT_OPTION_SPECIFIED_UNDERSCORE",
      normalize_underscore    => "ALIAS_USES_UNDERSCORE_BUT_OPTION_SPECIFIED_HYPHEN",
      test_noarg_isa          => 1,
      test_multiple           => [qw{a b}],
    };
    my @expected_argv= qw{ this_should_be_left_in_argv_because_noarg this_should_be_left_in_argv };
    my $config= Ytkit::Config->new($option_struct);
    $config->parse_argv(@test_argv);
    is_deeply($config->{result}, $expected_opt, "Options by Ytkit::Config::options");
    is_deeply($config->{left_argv}, \@expected_argv, "ARGV by Ytkit::Config::options");
    
    done_testing;
  };  
  
  subtest "hash-style option" => sub
  {
    my $option_struct=
    {
      parent => { child1 => { default => "aaa" },
                  child2 => { default => "bbb" },
                  child3 => { alias => ["c"], default => "ddd" }, },
    
    };
    
    my @test_argv= qw{
                       --parent-child1="ccc"
                       this_should_be_left_in_argv
                       -c eee
                     };
    
    my $expected_opt= 
    {
      parent => { child1 => "ccc",
                  child2 => "bbb", 
                  child3 => "eee", },
    };
  
    my @expected_argv= qw{ this_should_be_left_in_argv };
    my $config= Ytkit::Config->new($option_struct);
    $config->parse_argv(@test_argv);
    is_deeply($config->{result}, $expected_opt, "Options by Ytkit::Config::options");
    is_deeply($config->{left_argv}, \@expected_argv, "ARGV by Ytkit::Config::options");
    
    done_testing;
  };
  
  subtest "test for space-including value" => sub
  {
    my $option_struct=
    {
      doublequoted_space_with_equal    => {},
      doublequoted_space_without_equal => {},
      singlequoted_space_with_equal    => {},
      singlequoted_space_without_equal => {},
    };
    
    my @test_argv= (qq{--doublequoted_space_with_equal="s p a c e 1"},
                    qq{--doublequoted_space_without_equal}, qq{"s p a c e 2"},
                    qq{--singlequoted_space_with_equal="s p a c e 3"},
                    qq{--singlequoted_space_without_equal}, qq{"s p a c e 4"},
                    "this_should_be_left_in_argv",);
    my $expected_opt= 
    {
      doublequoted_space_with_equal    => "s p a c e 1",
      doublequoted_space_without_equal => "s p a c e 2",
      singlequoted_space_with_equal    => "s p a c e 3",
      singlequoted_space_without_equal => "s p a c e 4",
    };
    
    my @expected_argv= qw{ this_should_be_left_in_argv };
    my $config= Ytkit::Config->new($option_struct);
    $config->parse_argv(@test_argv);
    is_deeply($config->{result}, $expected_opt, "Options by Ytkit::Config::options");
    is_deeply($config->{left_argv}, \@expected_argv, "ARGV by Ytkit::Config::options");
    
    done_testing;
  };
  
  done_testing;
};

done_testing;

exit 0;
