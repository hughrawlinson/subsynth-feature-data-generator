//LPF lpf => FFT fft =^ Centroid c => dac;
FFT fft =^ Centroid c => blackhole;
fft =^ RMS r => blackhole;
fft =^ RollOff ro => blackhole;
fft =^ Flux f => blackhole;

0 => int DEMO;
8 => int FRAME_SIZE_EXPONENT;
Math.pow(2,FRAME_SIZE_EXPONENT) $ int => int FRAME_SIZE;
2 => int DETUNE_WIDTH;
1 => float OVERALL_VOLUME;
second / samp => float SAMP_RATE;

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
	Math.random()/(Math.RANDOM_MAX/DETUNE_WIDTH) => detune;
	setFreq(440);
	regain();
    refilter();
}

fun void setFreq(float f){
	setOsc1Freq(f);
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
    selectOscillator1Waveform(Math.randomf());
    selectOscillator2Waveform(Math.randomf());
	Math.randomf() => s2g.gain;
	Math.randomf() => t2g.gain;
	Math.randomf() => sq2g.gain;
	Math.randomf() => sw2g.gain;
}

fun void selectOscillator1Waveform(float vol){
	0 => s1g.gain;
	0 => t1g.gain;
	0 => sq1g.gain;
	0 => sw1g.gain;
    Math.random2(0,3) => int oscSelection;
    if(oscSelection == 0){
        vol => s1g.gain;
    }
    if(oscSelection == 1){
        vol => s1g.gain;
    }
    if(oscSelection == 2){
        vol => s1g.gain;
    }
    if(oscSelection == 3){
        vol => s1g.gain;
    }
}

fun void selectOscillator2Waveform(float vol){
    0 => s2g.gain;
	0 => t2g.gain;
	0 => sq2g.gain;
	0 => sw2g.gain;
    Math.random2(0,3) => int oscSelection;
    if(oscSelection == 0){
        vol => s2g.gain;
    }
    if(oscSelection == 1){
        vol => s2g.gain;
    }
    if(oscSelection == 2){
        vol => s2g.gain;
    }
    if(oscSelection == 3){
        vol => s2g.gain;
    }
}

fun void logParametersAndFeatures(){
    chout <= c.fval(0) * SAMP_RATE / 2 <= "," <= r.fval(0) <= "," <= ro.fval(0) <= "," <= f.fval(0) <= IO.newline();
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