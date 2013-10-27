#!/usr/bin/perl


use File::Temp qw(tempfile tempdir);

#$Global::debug = 1;
my $block = "30m";
debug("parallel --pipe --block $block -k --files -j150% transpose-par.pl\n");
my @files = `parallel --pipe --block $block -k --files -j150% transpose-par.pl`;
chomp(@files);
my $tmp = File::Temp::tempdir(CLEANUP => 0);
my $fifo = "$tmp/0000000";
my $cmd = "mkfifo $fifo; paste > $fifo ";
my (@fifos, @args);
my $args_len = 0;
my $max_line_length_allowed = `parallel --max-line-length-allowed`;

while(@files) {
    push @args, shift @files;
    $args_len += length $args[$#args] + 1;
    if(length $cmd + $args_len > $max_line_length_allowed) {
	unshift @files, pop @args;
	push @fifos, $fifo;
	if(fork()) {
	} else {
	    debug("($cmd @args &)\n");
	    `($cmd @args &)`;
	    exit($?);
	}
	$fifo++;
	$cmd = "mkfifo $fifo; paste > $fifo ";
	@args = ();
	$args_len = 0;
    }
}

if(@args) {
    push @fifos, $fifo;
    if(fork()) {
    } else {
	debug("($cmd @args &)\n");
	`($cmd @args &)`;
	exit($?);
    }
}

# make sure all fifos are created by the spawned shells
my @non_existing_fifos = @fifos;
while(@non_existing_fifos) {
    if(not -e $non_existing_fifos[0]) {
	usleep(1);
    } else {
	shift @non_existing_fifos;
    }
}

debug("paste @fifos\n");
system("paste @fifos");

unlink(@fifos);
rmdir($tmp);

sub usleep {
    # Sleep this many milliseconds.
    my $secs = shift;
    ::debug(int($secs),"ms ");
    select(undef, undef, undef, $secs/1000);
}

sub debug {
    # Returns: N/A
    $Global::debug or return;
    @_ = grep { defined $_ ? $_ : "" } @_;
    if($Global::fd{1}) {
	# Original stdout was saved
	my $stdout = $Global::fd{1};
        print $stdout @_;
    } else {
        print @_;
    }
}
