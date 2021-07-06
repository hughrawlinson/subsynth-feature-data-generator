default:
	rm training_data.csv;
	echo "centroid,rms,rolloff,flux,om,o1o,o2o,q,cutoff,detune" >> training_data.csv; chuck -s sub.ck | ruby data_sanitization.rb | grep -v e >> training_data.csv

normalize:
	rm training_data_normalized.csv
	node normalize-linebyline.js training_data.csv >> training_data_normalized.csv