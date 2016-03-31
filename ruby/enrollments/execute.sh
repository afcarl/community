#!/bin/bash

echo 'resetting the development database...'
rake db:drop
rake db:migrate

echo 'resetting the test database...'
rake db:drop RAILS_ENV=test
rake db:migrate RAILS_ENV=test

echo 'processing the csv data files...'
rake batch:process_csv_data 

echo 'producing reports to the tmp/ directory...'
rm tmp/*.txt
rake batch:courses_report  > tmp/courses_report.txt
rake batch:students_report > tmp/students_report.txt
rake batch:currently_active_report > tmp/currently_active_report.txt

echo 'done'
