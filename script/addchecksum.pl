#!/usr/bin/perl

#############################################################################
# To add a checksum to a subscription file, run the script like this:       #
#   perl addChecksum.pl subscription.txt                                    #
#############################################################################

use strict;
use warnings;
use Digest::MD5 qw(md5_base64);

die "Usage: $^X $0 subscription.txt\n" unless @ARGV;

#my $file = $ARGV[0];
foreach my $file (@ARGV) {
  my $data = readFile($file);

  # Get existing checksum.
  $data =~ /^.*!\s*checksum[\s\-:]+([\w\+\/=]+).*\n/gmi;
  my $oldchecksum = $1;

  # Remove already existing checksum.
  $data =~ s/^.*!\s*checksum[\s\-:]+([\w\+\/=]+).*\n//gmi;

  # Calculate new checksum: remove all CR symbols and empty
  # lines and get an MD5 checksum of the result (base64-encoded,
  # without the trailing = characters).
  my $checksumData = $data;
  $checksumData =~ s/\r//g;
  $checksumData =~ s/\n+/\n/g;

  # Calculate new checksum
  my $checksum = md5_base64($checksumData);

  # If the old checksum matches the new one bail.
  #if ($checksum eq $oldchecksum)
  #{
  #  $data = ();
  #  next;
  #}

  # Update the date.
  my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
  $year += 1900; # Year is years since 1900.
  my $todaysdate = "$mday $months[$mon] $year";
  $data =~ s/(^.*!.*Updated:\s*)(.*)\s*$/$1$todaysdate/gmi;

  # Recalculate the checksum as we've altered the date.
  $checksumData = $data;
  $checksumData =~ s/\r//g;
  $checksumData =~ s/\n+/\n/g;
  $checksum = md5_base64($checksumData);

  # Insert checksum into the file
  $data =~ s/(\r?\n)/$1! Checksum: $checksum$1/;

  writeFile($file, $data);
  $data = ();
}

sub readFile
{
  my $file = shift;

  open(local *FILE, "<", $file) || die "Could not read file '$file'";
  binmode(FILE);
  local $/;
  my $result = <FILE>;
  close(FILE);

  return $result;
}

sub writeFile
{
  my ($file, $contents) = @_;

  open(local *FILE, ">", $file) || die "Could not write file '$file'";
  binmode(FILE);
  print FILE $contents;
  close(FILE);
}
