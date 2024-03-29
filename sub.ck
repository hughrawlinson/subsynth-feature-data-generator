// print csv headers
chout <= "centroid,rms,rolloff,flux,om,o1o,o2o,q,cutoff,detune" <= IO.newline();

//LPF lpf => FFT fft =^ Centroid c => dac;
FFT fft =^ Centroid c => blackhole;
fft =^ RMS r => blackhole;
fft =^ RollOff ro => blackhole;
fft =^ Flux f => blackhole;

0 => int DEMO;
8 => int FRAME_SIZE_EXPONENT;
Math.pow(2,FRAME_SIZE_EXPONENT) $ int => int FRAME_SIZE;
2 => float DETUNE_WIDTH;
1 => float OVERALL_VOLUME;
second / samp => float SAMP_RATE;

0 => float om;
0 => int o1o;
0 => float o2v;
0 => int o2o;

LPF lpf => Gain mgain;
OVERALL_VOLUME => mgain.gain;
1 => lpf.Q;

if(DEMO>0){
    mgain => dac;
}
else{
    mgain => fft;
    fft.size(FRAME_SIZE);
    Windowing.hann(FRAME_SIZE) => fft.window;
}

SinOsc s1 => Gain s1g => lpf;
TriOsc t1 => Gain t1g => lpf;
SqrOsc sq1 => Gain sq1g => lpf;
SawOsc sw1 => Gain sw1g => lpf;

SinOsc s2 => Gain s2g => lpf;
TriOsc t2 => Gain t2g => lpf;
SqrOsc sq2 => Gain sq2g => lpf;
SawOsc sw2 => Gain sw2g => lpf;

0 => float detune;

//12 => int FRAME_SIZE_EXPONENT;

fun void rejig(){
	setFreq(440);
	regain();
    refilter();
}

fun void setFreq(float f){
	setOsc1Freq(f);
	Math.randomf()*DETUNE_WIDTH => detune;
	setOsc2Freq(f+detune);
}

fun void setOsc1Freq(float f){
	f => s1.freq;
	f => t1.freq;
	f => sq1.freq;
	f => sw1.freq;
}

fun void setOsc2Freq(float f){
	f => s2.freq;
	f => t2.freq;
	f => sq2.freq;
	f => sw2.freq;
}

fun void regain(){
    Math.randomf() => om;
    selectOscillator1Waveform(om);
    selectOscillator2Waveform(1-om);
}

fun void selectOscillator1Waveform(float vol){
	0 => s1g.gain;
	0 => t1g.gain;
	0 => sq1g.gain;
	0 => sw1g.gain;
    Math.random2(0,3) => int oscSelection;
    oscSelection => o1o;
    if(oscSelection == 0){
        vol => s1g.gain;
    }
    if(oscSelection == 1){
        vol => t1g.gain;
    }
    if(oscSelection == 2){
        vol => sq1g.gain;
    }
    if(oscSelection == 3){
        vol => sw1g.gain;
    }
}

fun void selectOscillator2Waveform(float vol){
    0 => s2g.gain;
	0 => t2g.gain;
	0 => sq2g.gain;
	0 => sw2g.gain;
    Math.random2(0,3) => int oscSelection;
    oscSelection => o2o;
    if(oscSelection == 0){
        vol => s2g.gain;
    }
    if(oscSelection == 1){
        vol => t2g.gain;
    }
    if(oscSelection == 2){
        vol => sq2g.gain;
    }
    if(oscSelection == 3){
        vol => sw2g.gain;
    }
}

fun void logParametersAndFeatures(){
    chout <= c.fval(0) * SAMP_RATE / 2 <= "," <= r.fval(0) <= "," <= ro.fval(0) <= "," <= f.fval(0) <= "," <= om <= "," <= o1o <= "," <= o2o <= "," <= lpf.Q() <= "," <= lpf.freq() <= "," <= detune<= IO.newline();
}

fun void refilter(){
    Math.randomf()*5 => lpf.Q;
    Math.randomf()*19000+100 => lpf.freq;
}

while(1){
	rejig();
    if(DEMO>0){
        FRAME_SIZE::ms => now;
    }
    else{
        c.upchuck();
        r.upchuck();
        ro.upchuck();
        f.upchuck();
        FRAME_SIZE::samp => now;
        logParametersAndFeatures();
    }
}