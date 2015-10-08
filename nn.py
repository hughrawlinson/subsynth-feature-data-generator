import csv
import string
from pybrain.tools.shortcuts import buildNetwork
from pybrain.datasets import SupervisedDataSet
from pybrain.supervised.trainers import BackpropTrainer
from pybrain.tools.validation import ModuleValidator

if __name__ == "__main__":
    net = buildNetwork(4, 6, 6, bias=True)
    ds = SupervisedDataSet(4, 6)
    mv = ModuleValidator()
    with open('example_data.csv', 'rb') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
        for row in spamreader:
            ds.addSample((float(row[0])/18000,float(row[1]),float(row[2]),float(row[3])/1.41), (float(row[4]),float(row[5])/3,float(row[6])/3,float(row[7])/5,float(row[8])/20000,float(row[9])/2))

    trainer = BackpropTrainer(net, ds)
    while(True):
        print "--------EPOCH--------"
        trainer.train();
        print "ERROR: "+mv.MSE(net,ds).astype('|S10')+"%"
        print net
        print net.params
