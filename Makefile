all: blink/blink.1 histogram/histogram.1 upsidedown/upsidedown.1

blink/blink.1: blink/blink
	pod2man blink/blink > blink/blink.1

histogram/histogram.1: histogram/histogram
	pod2man histogram/histogram > histogram/histogram.1

upsidedown/upsidedown.1: upsidedown/upsidedown
	pod2man upsidedown/upsidedown > upsidedown/upsidedown.1

install:
	parallel ln -sf `pwd`/{}/{} /usr/local/bin/{} ::: blink reniced em field forever neno rn stdout tracefile w4it-for-port-open upsidedown histogram goodpasswd
	parallel ln -sf `pwd`/{} /usr/local/share/man/man1/{/} ::: */*.1
