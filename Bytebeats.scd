/*
"http://kymatica.com/Software/BitWiz"
"http://wurstcaptures.untergrund.net/music/"
"http://pelulamu.net/countercomplex/music_formula_collection.txt"
"http://countercomplex.blogspot.fi/2011/10/algorithmic-symphonies-from-one-line-of.html"
"http://countercomplex.blogspot.fi/2011/10/some-deep-analysis-of-one-line-music.html"
*/

//Bytebeats in sc

(
Server.default.waitForBoot{

(
Ndef(\bytebeats, {
	//var sr = SampleRate.ir/6; //fix sample rate
	var sr = SampleRate.ir/MouseY.kr(1,10,1); //variable sample rate
	var freq=MouseX.kr(0.05,1000, -1);
	//var freq = 10;
	var n = 16; //bit resolution
	var t= Phasor.ar(1,freq*((2**n)/sr),0,((2**n)-1)); //creating a raising value from 0 to 2**n
	//t = t & (2**(n-1)); // few tests
	//equations: try one at the time
	//t = t * 4;
	//var counter = LFSaw.ar(0.5,0,3.5,3.5); // browse the equations
	var counter = LFDNoise0.ar(MouseY.kr(1,0.1),3.5,3.5);
	//counter.poll;
	t = Select.ar(counter,[

	t*(((t>>12)|(t>>8))&(63&(t>>4))),
	t*(((t>>9)|(t>>13))&(25&(t>>6))),
	t*(((t>>5)|(t>>8)) & 63),
	t*(((t>>11)&(t>>8))&(123&(t>>3))),
	t*(t>>8*((t>>15)|(t>>8))&(20|(t>>19)*5>>t|(t>>3))),
	t*(t>>((t>>9)|(t>>8))&(63&(t>>4))),
	(t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
	]);

	t = t % (2**(n));// avoiding number beyond 2**(bit resolution)
	t = t*(0.5**(n-1)) - 1;//scaling to -1, 1

	LeakDC.ar(t.dup);

}).play
//}.plot(1);
//}.scope
);

}
)