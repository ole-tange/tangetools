all: blink/blink.1 histogram/histogram.1

blink/blink.1: blink/blink
	pod2man blink/blink > blink/blink.1

histogram/histogram.1: histogram/histogram
	pod2man histogram/histogram > histogram/histogram.1

install:
	parallel ln -sf `pwd`/{}/{} /usr/local/bin/{} ::: blink reniced em field forever neno rn stdout tracefile w4it-for-port-open upsidedown histogram
	parallel ln -sf `pwd`/{}/{}.1 /usr/local/share/man/man1/{}.1 ::: blink histogram
