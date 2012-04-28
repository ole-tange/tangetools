install:
	parallel ln -sf `pwd`/{}/{} /usr/local/bin/{} ::: blink reniced em field forever neno rn stdout tracefile w4it-for-port-open
