var synaptic = require('synaptic');
var network = new synaptic.Architect.Perceptron(4,6,6);
var parse = require('csv-parse');
var fs = require('fs');
var trainer = new synaptic.Trainer(network);
var ds = [];

var parser = parse({delimiter: ','});
// Use the writable stream api
parser.on('readable', function(){
  while(record = parser.read()){
      ds.push({input:[row[0]/18000,row[1],row[2],row[3]]/1.41,output:[row[4],row[5]/3,row[6]/3,row[7]/5,row[8]/20000,row[9]/2]});
  }
});
parser.on('error', function(err){
  console.log(err.message);
});
parser.on('finish', function(){
	trainer.train(ds);
	console.log(network.toJSON());
});

fs.readFile('example_data.csv', function (err, data) {
	data = data.toString();
  if (err) throw err;
  var d = data.split("\n");
	for(r of d){
		parser.write(d);
	}
});

parser.end();
