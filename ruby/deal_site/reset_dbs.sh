#!/bin/bash

echo ''
echo 'dropping and creating dev and test dbs...'
rake db:drop
rake db:create
rake db:migrate

echo 'clearing the log files...'
rake log:clear

echo 'seeding dev db...'
rake db:seed

echo ''
echo 'rake db:test:prepare ...'
rake db:test:prepare

echo 'done'
echo ''
