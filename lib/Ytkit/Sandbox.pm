package Ytkit::Sandbox;

########################################################################
# Copyright (C) 2025  yoku0825
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
use JSON;
use base "Ytkit";

use Ytkit::IO qw{ _infof _notef _carpf _croakf _debugf } ;
use Ytkit::Sandbox::Node;

my $synopsis= q{  $ yt-sandbox --topology=replication --mysqld=8.4.5 };
my $script= sprintf("%s - Run sandbox mysqlds", $0);
my $description= << "EOS";
yt-sandbox deploies Sandbox mysqld into \$HOME/yt-sandbox/
EOS
my $allow_extra_argv= 1;

my @dict = qw{ alpha bravo charlie delta echo foxrot golf hotel india juliet
               kirlo lima mike november oscar papa quebec romeo sierra tango
               uniform victor whiskey xray yankee zulu };
my $docker_options = q{ --restart=on-failure -P -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -e MYSQL_ROOT_PASSWORD="""" -e MYSQL_ROOT_HOST=""%"" };

sub new
{
  my ($class, @orig_argv)= @_;
  my $config= _config();
  $config->parse_argv(@orig_argv);

  my $self= { _config => $config,
              %{$config->{result}},
              _members => {},
              _version_int => 0,
              top_directory => undef,
            };
  bless $self => $class;
  $self->handle_help;

  if (defined($self->{servers}))
  {
    if ($self->{topology} eq "replication" && $self->{servers} <= 1)
    {
      _croakf("Can't specify less equal than 2 servers for topology %s", $self->{topology});
    }
  }
  else
  {
    ### Default when --servers doesn't specify
    if ($self->{topology} eq "single")
    {
      $self->{servers} = 1;
    }
    elsif ($self->{topology} eq "replication" || $self->{topology} eq "gr")
    {
      $self->{servers} = 3;   ### Primary + 2 Replicas
    }
    else
    {
      _croakf("Unkown topology %s", $self->{topology});
    }
  }

  return $self;
}

sub prepare
{
  my ($self)= @_;

  $self->{mysqld} =~ /^(\d+)\.(\d+)(?:\.(\d+))?/;
  my $version_int= sprintf("%d%02d%02d", $1, $2, $3 // 99);   ### 99 if patch version is not specified like '8.4'
  $self->{mysqld} = sprintf("%d.%d", $1, $2) if $version_int =~ /\.99$/;
  _infof("version_int: %d from mysqld %s", $version_int, $self->{mysqld});
 
  ### group_replication only supports 8.0 and later
  if ($self->{topology} eq "gr" && $version_int < 80000)
  {
    _croakf("--topology=gr only supports --mysqld >= 8.0.0");
  }
  my $sandbox_base = $self->{sandbox_home};
  -d "$sandbox_base" || mkdir "$sandbox_base";
  my $dict_seq= 0;
  for (@dict)
  {
    $dict_seq++;
    my $top_directory= sprintf("%s/%s", $sandbox_base, $_);
    -e "$top_directory" && next;
    _notef("Generate Sandbox directry into %s", $top_directory);
    mkdir "$top_directory";
    $self->{top_directory}= $top_directory;
    $self->{basename}= $_;
    last;
  }

  if (!($self->{basename}))
  {
    _croakf("Can't create new directry into %s, please remove some directries and retry.", $sandbox_base);
  }

  open(my $hosts, ">", sprintf("%s/hosts", $self->{top_directory}));
  if ($version_int >= 80022)
  {
    $self->{container} = sprintf("container-registry.oracle.com/mysql/community-server:%s", $self->{mysqld});
  }
  else
  {
    $self->{container} = sprintf("mysql/mysql-server:%s", $self->{mysqld});
  }
  _infof("Using %s for mysqld %s", $self->{container}, $self->{mysqld});

  for (my $n= 1; $n <= $self->{servers}; $n++)
  {
    my $dir = sprintf("%s/node%d", $self->{top_directory}, $n);
    mkdir "$dir";
    my $datadir = sprintf("%s/datadir", $dir);
    mkdir "$datadir";
    my $hostname= sprintf("%s-%d", $self->{basename}, $n);
    _write_my_cnf(sprintf("%s/my.cnf", $dir),
                  $version_int,
                  $dict_seq * 100 + $n,
                  $self->{additional_config} // "");

    my $container_id;
    ### 5.5 and 5.6 must be handled manually
    if ($version_int lt 50700)
    {
      $container_id= $self->init_for_55_56($dir, $n);
    }
    else
    {
      my $cmd = sprintf("docker run -d --mount type=bind,source=%s/hosts,target=/etc/hosts " .
                          "--mount type=bind,source=%s/my.cnf,target=/etc/my.cnf " .
                          "--mount type=bind,source=%s,target=/var/lib/mysql " .
                          "--hostname=%s --name=%s %s %s",
                        $self->{top_directory},
                        $dir,
                        $datadir,
                        $hostname, $hostname, $docker_options, $self->{container});
      _infof("Docker command: %s", $cmd);
      $container_id= `$cmd`;
      chomp($container_id);
    }
    _croakf("container id get failed") if !($container_id);
    _infof("Docker container ID: %s", $container_id);

    my $ret = `docker inspect $container_id`;
    _debugf("Docker inspect: %s", $ret);
    my $info= from_json($ret);

    ### There are some varieties to get IPAddress.
    my $ipaddr= $info->[0]->{NetworkSettings}->{IPAddress} ? $info->[0]->{NetworkSettings}->{IPAddress} : 
                  $info->[0]->{NetworkSettings}->{Networks}->{bridge}->{IPAddress} ?  $info->[0]->{NetworkSettings}->{Networks}->{bridge}->{IPAddress} :
                    "";
    _croakf("Ipaddress cannot get from $ret") if !($ipaddr);
    _notef("Node%d Container Ipaddress: %s", $n, $ipaddr);

    ### Write files
    _write_script(sprintf("%s/start", $dir), sprintf("docker start %s", $container_id), 0755);
    _write_script(sprintf("%s/stop", $dir), sprintf("docker stop %s", $container_id), 0755);
    _write_script(sprintf("%s/restart", $dir), sprintf("docker restart %s", $container_id), 0755);
    _write_script(sprintf("%s/use", $dir),
                          sprintf(qq|if [[ \$# == 1 ]] ; then\n docker exec -it %s mysql -uroot -e "\$1"\nelse\n  docker exec -it %s mysql -uroot "\$\@"\nfi|,
                                  $container_id, $container_id),
                          0755);
    _write_script(sprintf("%s/destroy", $dir), sprintf("docker stop %s\ndocker rm %s\n", $container_id, $container_id), 0644);
    ### I don't add execute permission to destroy script

    $self->{_members}->{sprintf("node%d", $n)}= Ytkit::Sandbox::Node->new($ipaddr);
    $self->{_members}->{sprintf("node%d", $n)}->wait_until_mysqld_startup(60);
    printf($hosts "%s\t%s\n", $ipaddr, $hostname);

    if ($self->{topology} eq "replication" || $self->{topology} eq "gr")
    {
      if ($n == 1)
      {
        ### "m" aster
        symlink(sprintf("%s/use", $dir), sprintf("%s/m", $self->{top_directory}));
      }
      else
      {
        ### "s" lave numbering is node number minus 1
        symlink(sprintf("%s/use", $dir), sprintf("%s/s%d", $self->{top_directory}, $n - 1));
      }
    }
    else
    {
      symlink(sprintf("%s/use", $dir), sprintf("%s/n%d", $self->{top_directory}, $n));
    }
  }

  ### Write group files
  $self->_write_group_script("start_all", "start", 0755);
  $self->_write_group_script("stop_all", "stop", 0755);
  $self->_write_group_script("restart_all", "restart", 0755);
  $self->_write_group_script("use_all", "use", 0755);
  $self->_write_group_script("destroy_all", "destroy", 0644);
  ### I don't add execute permission to destroy script

  ### Topology specified scripts
  if ($self->{topology} eq "replication")
  {
    _write_script(sprintf("%s/check_replication", $self->{top_directory}),
                  _check_replication_script($version_int), 0755) if $self->{topology} eq "replication";
  }
  elsif ($self->{topology} eq "gr")
  {
    _write_script(sprintf("%s/check_group_replication", $self->{top_directory}),
                  _check_group_replication_script(), 0755);
  }

  close($hosts);
  $self->{_version_int}= $version_int;
}

sub setup_replication
{
  my ($self)= @_;

  return if $self->{topology} eq "single";

  ### "replication" or "cascade_replication"
  foreach my $node (sort(keys(%{$self->{_members}})))
  {
    _infof("Setup %s replication for %s", $self->{topology} eq "replication" ? "" : "group ", $node);
    my $instance= $self->{_members}->{$node};
    if ($self->{topology} eq "replication" || $self->{topology} eq "cascade_replication")
    {
      $instance->setup_replication;
      $instance->clear_gtid;

      if ($node eq "node1")
      {
        ### Primary, do nothing
      }
      else
      {
        my $gtid_mode = $self->{_version_int} ge 50600 ? 1 : 0;   ### 5.6 and later, 1
        $instance->follow_replication_source($self->{_members}->{"node1"}->{ipaddr}, $gtid_mode);
      }
    }
    elsif ($self->{topology} eq "gr")
    {
      $instance->setup_group_replication;
      $instance->clear_gtid;

      $instance->{instance}->exec_sql_with_croak(sprintf("SET PERSIST group_replication_group_seeds = '%s'",
                                                         join(",", map { sprintf("%s:13306", $_->{ipaddr}) } values(%{$self->{_members}}))));
      if ($node eq "node1")
      {
        ### Primary
        _infof("SET GLOBAL group_replication_bootstrap_group = ON");
        $instance->{instance}->exec_sql("SET GLOBAL group_replication_bootstrap_group = ON");
        _infof("START GROUP_REPLICATION");
        $instance->{instance}->exec_sql_with_croak("START GROUP_REPLICATION");
        _infof("SET GLOBAL group_replication_bootstrap_group = OFF");
        $instance->{instance}->exec_sql("SET GLOBAL group_replication_bootstrap_group = OFF");
      }
      else
      {
        ### Secondary
        _infof("START GROUP_REPLICATION");
        $instance->{instance}->exec_sql_with_croak("START GROUP_REPLICATION");
      }
    }
  }
}

sub info
{
  my ($self)= @_;

  my @buff;
  foreach (sort(keys(%{$self->{_members}})))
  {
    push(@buff, $self->{_members}->{$_}->{ipaddr});
  }

  return \@buff;
}

sub _write_group_script
{
  my ($self, $file_name, $loop_script, $permission)= @_;
  my $file_path= sprintf("%s/%s", $self->{top_directory}, $file_name);
  my $file_body= << 'EOF';
for file in %s/node*/%s ; do
  bash $file "$@"
done
EOF
  return _write_script($file_path, sprintf($file_body, $self->{top_directory}, $loop_script), $permission);
}

sub _write_script
{
  my ($file_path, $file_body, $permission) = @_;

  open(my $fh, ">", $file_path);
  print $fh '#!/bin/bash' . "\n";
  print $fh $file_body;
  close($fh);
  chmod $permission, $file_path;
  return 0;
}

sub _write_my_cnf
{
  my ($file_path, $version_int, $server_id, $additional_json) = @_;

  open(my $fh, ">", $file_path);
  my $terminology= $version_int ge 80400 ? "replica" : "slave";
  
  my $always = << "EOF";
[mysql]
skip-auto-rehash

[mysqld]
user = mysql
lower_case_table_names
log_bin = binlog
log_${terminology}_updates
server_id = $server_id
log_error = error.log
skip_name_resolve
EOF

  print $fh $always;
  if ($version_int ge 50600)
  {
    my $gtid = << "EOF";
gtid_mode = ON
enforce_gtid_consistency = ON
EOF
    print $fh $gtid;
  }

  if ($additional_json)
  {
    my $config= from_json($additional_json);

    while (my ($key, $value) = each(%$config))
    {
      printf($fh "%s = %s\n", $key, $value);
    }
  }

  close($fh);
} 

sub init_for_55_56
{
  ### 5.5 and 5.6 container couldn't initialize datadir correctly
  ### when option has --log-bin 
  my ($self, $dir, $n)= @_;

  my $init = sprintf("docker run --rm --mount type=bind,source=%s/my.cnf,target=/etc/my.cnf --mount type=bind,source=%s,target=/var/lib/mysql %s mysql_install_db --force 2>&1",
                     $dir, $dir . "/datadir", $self->{container});
  _infof("%s", $init);
  my $ret= `$init`;
  _debugf("%s", $ret);

  my $start= sprintf("docker run -d --mount type=bind,source=%s/hosts,target=/etc/hosts " .
                     "--mount type=bind,source=%s/my.cnf,target=/etc/my.cnf " .
                     "--mount type=bind,source=%s,target=/var/lib/mysql " .
                     "--hostname=%s-%d --name=%s-%d %s %s 2>&1",
                      $self->{top_directory},
                      $dir,
                      $dir . "/datadir",
                      $self->{basename}, $n, $self->{basename}, $n,
                      $docker_options, $self->{container});
  _infof("%s", $start);
  my $container_id= `$start`;
  chomp($container_id);

  ### TODO: waiting startup...
  sleep 3;
  my $update_root= sprintf(q|docker exec %s mysql -e "DELETE FROM mysql.user WHERE user = '' OR host <> 'localhost'; UPDATE mysql.user SET password = '', host = '' WHERE user = 'root'; FLUSH PRIVILEGES"|,
                           $container_id);
  _infof("%s", $update_root);
  my $updated= `$update_root`;
  _debugf("%s", $updated);

  return $container_id;
}

sub _check_replication_script
{
  my ($version_int) = @_;
  my $script= << 'EOF';
#!/bin/bash

workdir=$(readlink -f $(dirname $0))

cd $workdir

echo "### Replication Source"
./m -Ee "SHOW %s STATUS"

for f in ./s[1-9]* ; do
  echo "### Replica $f"
  $f -Ee "SHOW %s STATUS" | egrep 'Host|Running|Gtid|Behind'
done
EOF

  return $version_int >= 80400 ?
           sprintf($script, "BINARY LOG", "REPLICA") :
           sprintf($script, "MASTER", "SLAVE");

}

sub _check_group_replication_script
{
  my $script= << 'EOF';
#!/bin/bash

workdir=$(readlink -f $(dirname $0))

cd $workdir

for f in ./n[1-9] ; do
  echo "### Node $f"
  $f -sse "SELECT /* yt-sandbox ./check_group_replication */ CONCAT(member_host, IF(member_host = @@hostname, ' (this node)', '')) AS host, member_state, member_role, transactions_committed_all_members FROM performance_schema.replication_group_members JOIN performance_schema.replication_group_member_stats USING(member_id, channel_name) ORDER BY member_host"
done
EOF
  return $script;
}




sub _config
{
  my $program_option=
  {
    "mysqld" => { alias => ["mysqld", "tag"],
                  default => "8.4",
                  text => q{Container tag for create sandbox, taking care about cache.}, },
    "topology" => { alias => ["topology", "type", "t"],
                    default => "single",
                    isa => ["single", "replication", "gr"],
                    text => q{Replication topology.}, },
    "servers" => { alias => ["servers", "count", "server_count", "n"],
                   isa => qr{\d+},
                   text => q{How many servers are deployed}, },
    "sandbox_home" => { alias => ["sandbox_home", "home", "d"],
                        text => q{Base directry for create sandbox datadir and scripts},
                        default => $ENV{HOME} . "/yt-sandbox", },
    "additional_config" => { alias => ["additional_config", "config"],
                             default => '',
                             text => q{ Additional my.cnf option expressed by JSON }, },
  };

  my $config= Ytkit::Config->new({ %$program_option, 
                                   %$Ytkit::Config::COMMON_OPTION });
  $config->{_synopsis}= $synopsis;
  $config->{_description}= $description;
  $config->{_script}= $script;
  $config->{_allow_extra_argv}= $allow_extra_argv;
  return $config;
}

return 1;
