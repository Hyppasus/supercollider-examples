
/*############################################################################################################*/
//Feedback Oscillator
(
Server.default.waitForBoot{

	(
SynthDef(\feedbackOsc, {|out=0, mFrq= 313, mFB= 1, freq= 100, fB= 1, width= 0, mul= 500, ffreq=1000, rq=1, gate=1, attack=0.01, sustain=1, release=1|
	var w= [0, width*2pi];
	var buf= LocalBuf(1).clear;
	var buf2= LocalBuf(1, 2).clear;
	var osc= sin(LFSaw.ar(mFrq).range(0, 2pi)+(Dbufrd(buf)*mFB));
	var snd= Duty.ar(SampleDur.ir, 0, Dbufwr(osc, buf));
	var osc2= sin(LFSaw.ar(freq+(snd*mul)).range(0, 2pi)+(Dbufrd(buf2)*fB)+w);
	var snd2= Duty.ar(SampleDur.ir, 0, Dbufwr(osc2, buf2));
	//var filter= RLPF.ar(snd2, ffreq, rq);
	var filter = DFM1.ar(snd2, ffreq, rq);
	//var env = EnvGen.ar(Env.asr(attack,sustain,release),gate,doneAction:2);
	Out.ar(out,filter);
}).add;
);

~id = s.nextNodeID;
s.sync;
s.sendMsg(\s_new, "feedbackOsc", ~id, 1, 1);
// controlling with a GUI
s.sync;
(
		w=Window.new(" FeedbackOsc ",Rect(128, 346, 423, 204)).front;
		w.view.decorator=FlowLayout(w.view.bounds);
		w.view.decorator.gap=5@2;
		EZSlider(w,370@20,"mFreq ", [2, 20000, 'exp', 0, 313, " Hz"].asSpec,{|ez| s.sendMsg(\n_set, ~id, \mFrq, ez.value);});
		EZSlider(w,370@20,"mFB ", [0.0, 1, \lin, 0.01, 1].asSpec,{|ez| s.sendMsg(\n_set, ~id, \mFB, ez.value);});
		EZSlider(w,370@20,"Freq ", [2, 20000, 'exp', 0, 100, " Hz"].asSpec,{|ez| s.sendMsg(\n_set, ~id, \freq, ez.value);});
		EZSlider(w,370@20,"fB ", [0.0, 1, \lin, 0.01, 1].asSpec,{|ez| s.sendMsg(\n_set, ~id, \fB, ez.value);});
		EZSlider(w,370@20,"Width ", [0.0, 1, \lin, 0.01, 0].asSpec,{|ez| s.sendMsg(\n_set, ~id, \width, ez.value);});
		EZSlider(w,370@20,"mul ", [0.0, 10000, \lin, 0.01, 500].asSpec,{|ez| s.sendMsg(\n_set, ~id, \mul, ez.value);});
		EZSlider(w,370@20,"ffreq ", [2, 20000, 'exp', 0, 1000, " Hz"].asSpec,{|ez| s.sendMsg(\n_set, ~id, \ffreq, ez.value);});
		EZSlider(w,370@20,"rq ", [0.0, 1, \lin, 0.01, 1].asSpec,{|ez| s.sendMsg(\n_set, ~id, \rq, ez.value);});
);
}
);

/*############################################################################################################*/