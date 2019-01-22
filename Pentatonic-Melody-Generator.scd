//This example illustrate the basic use of Conditional Statements (if) and Loop Control Statements
/*
The goal is to create an
################     Automatic Pentatonic Melody Generator #######################

The program should play notes in a pentatonic scale within an octave.
The resulting melodic sequence should include a pedal note.
The duration and timbre of each note should be automatically generated.
The user must control global parameters such as tempo, volume, number of notes to play, octave register, note pedal, and eventually change the scale.
*/
//The synthesizer to play the sounds and to boot the server
(
Server.default.waitForBoot{
SynthDef(\saw,{
    arg freq=440,amp=0.4,release=1,detune=1.01,cutoff=5000,q=0.5;
    var env = Linen.kr(Impulse.kr(0),0,1,release,doneAction:2);
    var osc = Saw.ar([freq,freq*detune],env);
    var sig = RLPF.ar(osc,XLine.ar(cutoff,100,release),q.reciprocal,amp);
	Out.ar(0,sig)}
	    ).add;
};
);


//Automatic Pentatonic Melody Generator version I
(
{
	var scale = [0,2,3,7,8];
	//var scale = [0,2,4,7,9];
	var amountOfNotes = 100;
	var tempo = (60/120)*(1/4);
	var volume = 0.5;
	var root = 48;
	var pedal = 36;




	amountOfNotes.do{|i|
			var x = 10.rand;
			var note = 60;

		if(scale.includes(x)){note=x+root}{note=pedal};
		s.sendMsg(\s_new,'saw',s.nextNodeID,1,1,\freq,note.midicps,\release,tempo,\amp,volume);
		tempo.wait;
	}
}.fork
);



//Automatic Pentatonic Melody Generator version II
(
{
	//var scale = [0,2,4,7,9];
	var scale = [0,2,3,7,8];
	var amountOfNotes = 100;
	var tempo = (60/120)*(1/4);
	var volume = 0.5;
	var root = 48;
	var pedal = 36;



	amountOfNotes.do{|i|
			var x = 10.rand;
			var note = 60;
			var cutoff = 5000;

		if(scale.includes(x)){note=x+root}{note=pedal};
		//if([0,2,4,7,9].includes(x)){cutoff=[1,5,10].choose*1000}{cutoff=100};
		if(scale.includes(x)){cutoff=((1..10)*1000).choose}{cutoff=[500,15000].choose};
		s.sendMsg(\s_new,'saw',s.nextNodeID,1,1,\freq,note.midicps,\release,tempo,\cutoff,cutoff,\q,0.95,\amp,volume);
		tempo.wait;
	}
}.fork
);


//Automatic Pentatonic Melody Generator version III
(
{
	//var scale = [0,2,4,7,9]; // major pentatonic
	var scale = [0,2,3,7,8]; // minor pentatonic
	var amountOfNotes = 1000;
	var tempo = (60/120);
	var volume = 0.5;
	var noteduration = (1/4);
	var root = 48;
	var pedal = 36;


	amountOfNotes.do{|i|
			var x = 10.rand;
			var note = 60;
			var cutoff = 5000;
		if(scale.includes(x)){note=x+root}{note=pedal};
		//if([0,2,4,7,9].includes(x)){cutoff=3000}{cutoff=[500,1000,10000].choose};
		if(scale.includes(x)){cutoff=((1..10)*1000).choose}{cutoff=[500,15000].choose};
		case
		{x==0}{noteduration=1/2}
		{x>0 and:x<8}{noteduration=1/4}
		{x==8 or:x==9}{noteduration=1};
		//[note,cutoff,noteduration].postln;
		s.sendMsg(\s_new,'saw',s.nextNodeID,1,1,\freq,note.midicps,\release,tempo,\cutoff,cutoff,\q,0.97,\amp,volume);
		(tempo*noteduration).wait;
	}
}.fork
);

