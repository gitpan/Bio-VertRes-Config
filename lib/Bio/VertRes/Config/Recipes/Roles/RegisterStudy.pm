package Bio::VertRes::Config::Recipes::Roles::RegisterStudy;
# ABSTRACT: Moose Role for registering a study


use Moose::Role;
use Bio::VertRes::Config::Pipelines::QC;
use Bio::VertRes::Config::RegisterStudy;

# Register all the studies passed in the project limits array
after 'create' => sub { 
  my ($self) = @_;
  
  if(defined($self->limits->{project}))
  {
    for my $study_name ( @{$self->limits->{project}} )
    {
      my $pipeline = Bio::VertRes::Config::RegisterStudy->new(
        database    => $self->database, 
        study_name  => $study_name, 
        config_base => $self->config_base
      );
      $pipeline->register_study_name();
    }
  }
};

sub add_qc_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::QC->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          config_base                    => $self->config_base,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          reference                      => $self->reference,
          reference_lookup_file          => $self->reference_lookup_file
      )
  );
  return ;
}


no Moose;
1;

__END__

=pod

=head1 NAME

Bio::VertRes::Config::Recipes::Roles::RegisterStudy - Moose Role for registering a study

=head1 VERSION

version 1.133090

=head1 SYNOPSIS

Moose Role for registering a study

   with 'Bio::VertRes::Config::Recipes::Roles::RegisterStudy';

=head1 METHODS

=head2 create

Hooks into the create method after the base method is run to register a study

=head2 add_qc_config

Method with takes in the pipeline config array and adds the qc config to it.

=head1 AUTHOR

Andrew J. Page <ap13@sanger.ac.uk>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Wellcome Trust Sanger Institute.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
