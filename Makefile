all: blink/blink.1 histogram/histogram.1 upsidedown/upsidedown.1 tracefile/tracefile.1 timestamp/timestamp.1 rand/rand.1

blink/blink.1: blink/blink
	pod2man blink/blink > blink/blink.1

histogram/histogram.1: histogram/histogram
	pod2man histogram/histogram > histogram/histogram.1

rand/rand.1: rand/rand
	pod2man rand/rand > rand/rand.1

timestamp/timestamp.1: timestamp/timestamp
	pod2man timestamp/timestamp > timestamp/timestamp.1

tracefile/tracefile.1: tracefile/tracefile.pod
	pod2man tracefile/tracefile.pod > tracefile/tracefile.1

upsidedown/upsidedown.1: upsidedown/upsidedown
	pod2man upsidedown/upsidedown > upsidedown/upsidedown.1

wssh/wssh.1: wssh/wssh
	#pod2man wssh/wssh > wssh/wssh.1

install:
	mkdir -p /usr/local/bin
	parallel eval ln -sf `pwd`/*/{} /usr/local/bin/{} ::: blink reniced em field forever neno rn stdout tracefile w4it-for-port-open upsidedown histogram goodpasswd mtrr not summer timestamp transpose wssh aptsearch rand
	mkdir -p /usr/local/share/man/man1
	parallel ln -sf `pwd`/{} /usr/local/share/man/man1/{/} ::: */*.1
