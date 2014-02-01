#!/bin/bash

echo "capture `date`"
python locomotive_main.py capture > output/run_capture.txt 

echo "gen_cat_file `date`" 
python locomotive_main.py gen_cat_file > output/run_gen_cat_file.txt

echo "knn_simple `date`" 
python locomotive_main.py knn_simple > output/run_knn_simple.txt

echo "recommend_by_cats `date`"  
python locomotive_main.py recommend_by_cats > output/run_recommend_by_cats.txt

echo "classify `date`"  
python locomotive_main.py classify > output/run_classify.txt 

echo "classify_reuters `date`"  
python locomotive_main.py classify_reuters > output/run_classify_reuters.txt

echo "knn_reuters `date`"  
python locomotive_main.py knn_reuters > output/run_knn_reuters.txt

echo "done `date`"
  