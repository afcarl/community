#!/bin/bash 

# Copyright (C) 2012 Chris Joakim, joakimsoftware.com. 

# The problem:
# You've created a git project, perhaps a public one github. But within the
# git history of the project there are sensitive values such as passwords, 
# which have since been removed from the current version of the file(s). 
# You want to prune the project of all history except for the current version
# of each file.
# 
# The solution:
# Remove the .git/ directory which contains the history, and then recreate it
# with the following commands.
# 
# rm -rf .git
# git init
# git add .
# git commit -a -m "Initial commit"
# git remote add origin git@github.com:your-id/your-project.git
# git push -f
