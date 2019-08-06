/*
Complex dual oscillator modulating each other in frequency, phase and amplitude. The output can be either each oscillator separetely or a folded or wraped version of oscillator one.
Enjoy it!
Alejandro Olarte
*/
/*##############################################################################################################*/

(
Ndef(\complexosc, {
	var osc1=1, osc2=1, fbk, outlet, folded, wraped;
	fbk = LocalIn.ar(2,0);
	osc1 = SinOsc.ar(\freq1.ar(40)+(fbk[1].range(1,1000)*\fm1.ar(0.1)), 0+(fbk[1].range(-pi,pi)*\pm1.ar(0)), \mul1.ar(1)+(fbk[1]*\ring1.ar(1)), \add1.ar(0));
	osc2 = SinOsc.ar(\freq2.ar(0.5)+(fbk[0].range(1,1000)*\fm2.ar(0.1)), 0+(fbk[1].range(-pi,pi)*\pm2.ar(0)), \mul2.ar(1)+(fbk[0]*\ring2.ar(1)), \add2.ar(0));
	LocalOut.ar([osc1, osc2]);
	folded = Fold.ar(osc1!2,\fold.ar(0.8).neg,\fold.ar(0.8));
	wraped = Wrap.ar(osc1!2,\wrap.ar(0.9).neg,\wrap.ar(0.9));
	outlet = LeakDC.ar(Select.ar(\switch.kr(2), [osc1!2, osc2!2, folded, wraped]));
}
).play

);

(
Spec.add(\freq1, ControlSpec(0.1, 18000.0, \exp, 0, 70, "Hz"));//Frequency control for first oscillator
Spec.add(\freq2, ControlSpec(0.1, 18000.0, \exp, 0, 4, "Hz"));//Frequency control for second oscillator
Spec.add(\pm1, ControlSpec(0.0, pi, \lin, 0, 0, "rad"));//Amount of Phase modulation for first oscillator
Spec.add(\pm2, ControlSpec(0.0, pi, \lin, 0, 0, "rad"));//Amount of Phase modulation for second oscillator
Spec.add(\mul1, ControlSpec(0.0, 1, \lin, 0, 0));//Amplitude control of first oscillator
Spec.add(\mul2, ControlSpec(0.0, 1, \lin, 0, 0));//Amplitude control of second oscillator
Spec.add(\add1, ControlSpec(0.0, 1, \lin, 0, 0));//DC offset for first oscillator
Spec.add(\add2, ControlSpec(0.0, 1, \lin, 0, 0));//DC offset for second oscillator
Spec.add(\fm1, ControlSpec(0.0, 1, \lin, 0, 0));//Amount of Frequency modulation for first oscillator
Spec.add(\fm2, ControlSpec(0.0, 1, \lin, 0, 0));//Amount of Frequency modulation for second oscillator
Spec.add(\ring1, ControlSpec(0.0, 1, \lin, 0, 0));//Amount of Ring modulation for first oscillator
Spec.add(\ring2, ControlSpec(0.0, 1, \lin, 0, 0));//Amount of Ring modulation for second oscillator
Spec.add(\switch, ControlSpec(0, 3, \lin, 1, 2));//Four positions switch: osc1, osc2, Folded, Wraped
Spec.add(\fold, ControlSpec(0, 1, \lin, 0, 0));//Fold thresholds
Spec.add(\wrap, ControlSpec(0, 1, \lin, 0, 0));//Wrap thresholds
);

//Sequence the frequency of both oscillators and explore the controls with the GUI
(
Pdef(\complexoscKr, Pbind(
	\type, \set,
	\args, [\freq1, \freq2],
	\id, Pfunc({ Ndef(\complexosc).group.nodeID }),
	\freq1, Pxrand(([1,4,6,5,8,2,3,1]+17).midicps,inf),
	\freq2, Pxrand(([1,4,6,5,8,2,3,1]+48).midicps,inf),
	\dur, Pxrand([0.25, 0.5]*0.5,inf)
)).play;
Ndef(\complexosc).gui;
);

NdefMixer(s);
Ndef(\complexosc).clear;
Ndef(\complexosc).pause;
Ndef(\complexosc).resume;
Ndef(\complexosc).play;
Pdef(\complexoscKr).pause;
Pdef(\complexoscKr).resume;
Pdef.clear;
Ndef.clear;

/*##############################################################################################################*/
//Alternative sequencing
(
Ndef(\stepseq, {
	Demand.ar(Impulse.ar(4), 0, { Dseq([1, 2, 3, 4, 5], inf) } * 100);
}
)
);

Ndef(\complexosc) <<>.freq1 Ndef(\stepseq);
Ndef(\stepseq).play;
Ndef(\stepseq).clear;

//MIDI control
MIDIClient.init;
MIDIIn.connectAll;
MIDIFunc.trace(bool: true);
MIDIFunc.trace(bool: false);

(
MIDIdef.noteOn(\notes1, { |vel,val|Ndef(\complexosc).set(\freq1, \freq.asSpec.map(val/127))},chan:0);
MIDIdef.noteOn(\notes2, { |vel,val|Ndef(\complexosc).set(\freq2, \freq.asSpec.map(val/127))},chan:1);
Spec.add(\freq, [10, 10000, \exp]);
);
(
MIDIdef.cc(\knob1, { |val|Ndef(\complexosc).set(\fm1, val/127);}, ccNum: 10);
MIDIdef.cc(\knob2, { |val|Ndef(\complexosc).set(\fm2, val/127);}, ccNum: 11);
MIDIdef.cc(\knob3, { |val|Ndef(\complexosc).set(\ring1, val/127);}, ccNum: 12);
MIDIdef.cc(\knob4, { |val|Ndef(\complexosc).set(\ring2, val/127);}, ccNum: 13);
MIDIdef.cc(\knob5, { |val|Ndef(\complexosc).set(\pm1, val/127);}, ccNum: 14);
MIDIdef.cc(\knob6, { |val|Ndef(\complexosc).set(\pm2, val/127);}, ccNum: 15);
MIDIdef.cc(\knob7, { |val|Ndef(\complexosc).set(\mul1, val/127);}, ccNum: 16);
MIDIdef.cc(\knob8, { |val|Ndef(\complexosc).set(\mul2, val/127);}, ccNum: 17);
MIDIdef.cc(\knob9, { |val|Ndef(\complexosc).set(\add1, val/127);}, ccNum: 18);
MIDIdef.cc(\knob10, { |val|Ndef(\complexosc).set(\add2, val/127);}, ccNum: 19);
MIDIdef.cc(\knob11, { |val|Ndef(\complexosc).set(\fold, val/127);}, ccNum: 20);
MIDIdef.cc(\knob12, { |val|Ndef(\complexosc).set(\wrap, val/127);}, ccNum: 21);
MIDIdef.cc(\knob13, { |val|Ndef(\complexosc).set(\output, val.linlin(0,127,0,3));}, ccNum: 21);
);

MIDIdef.freeAll;

//Sequencing everything
(
Pdef(\complexoscKr, Pbind(
	\type, \set,
	\args, [\freq1, \freq2, \fm1, \fm2, \ring1, \ring2, \mul1, \mul2, \add1, \add2, \fold, \wrap],
	\id, Pfunc({ Ndef(\complexosc).group.nodeID }),
	\freq1, Pxrand(([1,4,6,5,8,2,3,1]+24).midicps,inf),
	\freq2, Pxrand(([1,4,6,5,8,2,3,1]+48).midicps,inf),
	//\fm1, Pwhite(0,0.2,inf),
	\fm1, 0.143219,
	//\fm2, Pwhite(0,0.8,inf),
	\fm2, 0.2345,
	//\pm1, Pseq([-pi,0,pi],inf),
	\pm1, 0.013,
	//\pm2, Pwhite(-pi,pi,inf),
	\pm2, 0.081,
	//\ring1, Pwhite(0,0.8,inf),
	\ring1, 0.1997,
	//\ring2, Pwhite(0,0.8,inf),
	\ring2, 0.299,
	//\mul1, Pwhite(0.8,0.99,inf),
	\mul1, 0.99,
	//\mul2, Pwhite(0.01,0.49,inf),
	\mul2, 0.274,
	\add1, 0,
	\add2, -0.9,
	\fold, 0.9719,
	\wrap, 0.7191,
	//\dur, 0.25
	\dur, Pxrand([0.25, 0.5]*0.5,inf)
)).play;
);

Pdef.clear;
Ndef.clear;
Pdef(\complexoscKr).pause;
Pdef(\complexoscKr).resume;
Ndef(\complexosc).pause;
Ndef(\complexosc).resume;
Ndef(\complexosc).gui;

//Notes
//Pdef(\coDef, Pbind(*Ndef(\complexosc).specs.collect(_.default).asPairs));
//\args, Ndef(\complexosc).specs.keys.asArray,



