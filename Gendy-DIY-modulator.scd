/* Oscillator with gendy inspired modulator*/
Server.default.options.sampleRate_(96000);
Server.default.options.blockSize_(2);
//Version 1 with EnvGen.ar
(
Ndef(\xen,{
	arg freq=440, minFreq=20, maxFreq=2000, minlevel= -1, maxlevel=1, mindur=0.01, maxdur=0.1, mincurves= -5, maxcurves=5, ffreqLPF=20000, ffreqHPF=100, pos=0, sel=0, amp=1;
	var env, sound, levels, levelsKr, durations, curves, size=12, trig;
	trig = Impulse.ar(freq);
	levels = Array.fill(size,{TRand.ar(minlevel, maxlevel, trig)});
	durations = Array.fill(size-1,{TRand.ar(mindur, maxdur,trig)});
	curves = Array.fill(size-1,{TRand.ar(mincurves, maxcurves,trig)});
	env = EnvGen.ar(
				Env(
					levels,
					//durations.normalizeSum, //to experiment!
					durations,
					curves
		),
	trig,
	timeScale:freq.reciprocal,
	);
	sound = env;
	sound = LPF.ar(sound, ffreqLPF);
	sound = HPF.ar(sound, ffreqHPF);
	sound = Select.ar(sel,[sound,SinOsc.ar(sound.range(minFreq,maxFreq))]);
	sound = Pan2.ar(sound, pos, amp);

}
).play
);

// Version 2 with DemandEnvGen
(
Ndef(\xen,{
	arg freq=440, minFreq=20, maxFreq=2000, minlevel= -1, maxlevel=1, mindur=0.01, maxdur=0.1, mincurves= -5, maxcurves=5, ffreqLPF=20000, ffreqHPF=100, pos=0, sel=0, amp=1;
	var env, sound, levels, levelsKr, durations, curves, size=12, trig;
	trig = Impulse.ar(freq);
	levels = Array.fill(size,{TRand.ar(minlevel, maxlevel, trig)});
	durations = Array.fill(size-1,{TRand.ar(mindur, maxdur,trig)});
	curves = Array.fill(size-1,{TRand.ar(mincurves, maxcurves,trig)});
	env = DemandEnvGen.ar(
		Dseq(levels,inf),
		//Dseq(durations,inf),
		Dseq(durations.normalizeSum,inf),
		Dseq(curves,inf),
	trig,
	timeScale:freq.reciprocal,
	);
	sound = env;
	sound = LPF.ar(sound, ffreqLPF);
	sound = HPF.ar(sound, ffreqHPF);
	sound = Select.ar(sel,[sound,SinOsc.ar(sound.range(minFreq,maxFreq))]);
	sound = Pan2.ar(sound, pos, amp);

}
).play
);
(
		Spec.add(\freq, ControlSpec(1, 18000.0, \exp, 0, 70, "Hz"));//Frequency control
		Spec.add(\minFreq, ControlSpec(20, 20000.0, \exp, 0, 70, "Hz"));//Works only for the modulator range
		Spec.add(\maxFreq, ControlSpec(20, 20000.0, \exp, 0, 70, "Hz"));//Works only for the modulator range
		Spec.add(\minlevel, ControlSpec(-1.0, 0, \lin, 0, 0));//minimum possible level
		Spec.add(\maxlevel, ControlSpec(0.0, 1, \lin, 0, 0));//maximum possible level
		Spec.add(\mindur, ControlSpec(0.0, 1, \lin, 0.0, 0));//minimum possible duration between the points
		Spec.add(\maxdur, ControlSpec(0.0, 1, \lin, 0.0, 0));//maximum possible duration between the points
		Spec.add(\mincurves, ControlSpec(-5, 5, \lin, 0.0, 0.0));//shape of the curves
		Spec.add(\maxcurves, ControlSpec(-5, 5, \lin, 0.0, 0.0));//shape of the curves
		Spec.add(\ffreqLPF, ControlSpec(10, 20000, \exp, 0, 1000, "Hz"));//Frequency control for filter
		Spec.add(\ffreqHPF, ControlSpec(10, 18000, \exp, 0, 1000, "Hz"));//Frequency control for filter
		Spec.add(\sel, ControlSpec(0, 1, \lin, 1, 0, "selector"));//Select to listen as an oscillator or as a modulator
		Spec.add(\pos, ControlSpec(-1, 1, \lin, 0, 0, "pan"));//
		Spec.add(\amp, ControlSpec(0.0, 1, \lin, 0, 0, "amp"));//

);


NdefMixer(s);
Ndef(\xen).gui;
Ndef(\xen).clear;
Ndef(\xen).pause;
Ndef(\xen).resume;
Ndef(\xen).play;
Pdef(\xenKr).pause;
Pdef(\xenKr).resume;
Pdef.clear;
Ndef.clear;






