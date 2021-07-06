import csv
import string
from sklearn.ensemble import RandomForestRegressor

if __name__ == "__main__":
    rfr = new RandomForestRegressor()s
    with open('example_data.csv', 'rb') as csvfile:
        reader = csv.reader(csvfile, delimiter=',', quotechar='|')
        for row in reader:
            ds.addSample((float(row[0]),float(row[1]),float(row[2]),float(row[3])), (float(row[4]),float(row[5]),float(row[6]),float(row[7]),float(row[8]),float(row[9])))
sww
