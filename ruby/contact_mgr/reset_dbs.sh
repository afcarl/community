#!/bin/bash

echo ''
echo 'dropping and creating dev and test dbs...'
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:migrate

echo 'clearing logs...'
bundle exec rake log:clear

echo 'seeding dev db...'
bundle exec rake db:seed

echo 'done'
echo ''
