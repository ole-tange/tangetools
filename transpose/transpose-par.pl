#!/usr/bin/perl

#!/usr/local/bin/parallel --shebang-wrap --pipe --block 10m -k --files /usr/bin/perl | xargs paste

use Text::CSV;
use File::Temp qw(tempfile tempdir);

my $csv;
my (@table);
my $first_line = 1;
my $col = 0;
while(my $l = <>) {
    if($first_line) {
	my $csv_setting = guess_csv_setting($l);
	$csv = Text::CSV->new($csv_setting)
	    or die "Cannot use CSV: ".Text::CSV->error_diag ();
	$first_line = 0;
    }
    if(not $csv->parse($l)) {
	die "CSV has unexpected format";
    }
    # append to each row
    my $row = 0;
    
    for($csv->fields()) {
	$table[$row][$col] = defined($_) ? $_ : '';
	$row++;
    }
    $col++;
}

print map { join("\t",@$_),"\n" } @table;

sub guess_csv_setting {
    # Based on a single line guess the csv_setting
    return { binary => 1 };
}
