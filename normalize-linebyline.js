'use strict';
(function(){
    var LineByLineReader = require('line-by-line');
    var fs = require('fs');

    var lr = new LineByLineReader(process.argv[2]);

    lr.on('error', function (err) {
        // 'err' contains error object
    });

    let header = 0;

    lr.on('line', function (line) {
        if(header>0){
            let record = new Record(line.split(','));
            record.normalize();
            console.log(record.toString());
        }
        else{
            console.log(line);
            header++;
        }
    });

    lr.on('end', function () {
        // All lines are read, file is closed now.
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
    }

    Record.prototype.normalize = function(){
        for(var key of Object.keys(this.normalizationCoefficients)){
            this[key] = this[key]/this.normalizationCoefficients[key];
        }
    }

    Record.prototype.toString = function(){
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
})();
