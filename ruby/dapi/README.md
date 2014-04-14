## DAPI README

### Setup

#### Homebrew - package manager for Apple OS X

```
$ brew install postgresql
$ brew install phantomjs
```

#### PostgreSQL Database Setup

$ psql template1

```
template1=# create role dapi_user with createdb login password 'secret';
template1=# create database dapi_development owner dapi_user;
template1=# create database dapi_test owner dapi_user;
template1=# create database dapi_production owner dapi_user;
template1=# \l
template1=# \q
```

#### Environment variables

Set and export the following to their appropriate variables in your environment(s):

```
DESK_TOKEN=...
DESK_TOKEN_SECRET=...
DESK_CONSUMER_KEY=...
DESK_CONSUMER_SECRET=...
DESK_SUBDOMAIN=...
```

These are used by the DeskApi::Client from the 'desk_api' gem.

### Testing and Code Coverage

```
$ rake test
$ cucumber
```

View the SimpleCov reports file 'coverage/index.html' with your browser.
Currently, 75.36% of the code is covered.

Optionally, test the page resources for the app running at http://localhost:3000.
See the report in the console, and file tmp/page_resources_screenshot.png.

```
$ phantomjs test/phantom/page_resources.coffee --render
```

#### Heroku Deployment

First push the desired code to github on the master branch, then:

```
$ git push heroku master
$ heroku logs -n 1000
```

Then view the deployed application at http://stormy-savannah-5971.herokuapp.com/

#### Unfinished Business

- Assigning label to first case in the case filter; not sure what this means yet.
- Consider caching responses from Desk.com, such as cases.  Not sure how dynamic this list is.
- Additional testing of the create-label functionality.
