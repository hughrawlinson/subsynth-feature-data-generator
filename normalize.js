var parse = require('csv-parse');
var fs = require('fs');

var parser = parse({delimiter:','});

parser.on('readable',function(){
	console.log('yo');
	while(record = parser.read()){
		record = new Record(record);
		console.log(record);
	}
});

parser.on('error',function(err){
	console.log(err.message);
});

parser.on('finish',function(){
	//done
});

fs.readFile('example_data.csv', function(err,data){
	data = data.toString();
	if(err) throw err;
	var d = data.split('\n');
	for(r of d){
		parser.write(d);
	}
	parser.end();
});

function Record(row){
	this.centroid = row[0];
	this.rms = row[1];
	this.rolloff = row[2];
	this.flux = row[3];
	this.oscillatorMix = row[4];
	this.oscillator1Type = row[5];
	this.oscillator2Type = row[6];
	this.resonance = row[7];
	this.cutoffFrequency = row[8];
	this.detune = row[9];
	this.normalize();
	this.prototype.normalize = function(){
		for(key of this.normalizationCoefficients.keys()){
			this[key] = this[key]/this.normalizationCoefficients[key];
		}
	}
	this.normalizationCoefficients = {
		centroid:18000,
		rms:1,
		rolloff:1,
		flux:1.41,
		oscillatorMix:1,
		oscillator1Type:3,
		oscillator2Type:3,
		resonance:5,
		cutoffFrequency:20000,
		detune:2
	}
	this.prototype.toString = function(){
		return [
			this.centroid,
			this.rms,
			this.rolloff,
			this.flux,
			this.oscillatorMix,
			this.oscillator1Type,
			this.oscillator2Type,
			this.resonance,
			this.cutoffFrequency,
			this.detune].join(",");
	}
}
