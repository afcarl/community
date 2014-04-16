## CM - Contact Manager

### Workstation Setup

#### homebrew

Install the following packages for CM (Contact Manager) development.

```
$ brew install mysql
$ brew install phantomjs
```

#### Database Setup

##### MySQL

Execute the following commands to setup the necessary databases on your development
workstation.  Substitute 'xxx', below, with your root mysql database passord.

```
$ mysql -u root -p

mysql> create database cm_development;
mysql> grant all on cm_development.* to 'root' identified by 'xxx';
mysql> grant all on cm_development.* to 'cm'@'localhost' identified by 'cm';
mysql> grant all on cm_development.* to 'cm' identified by 'cm';

mysql> create database cm_test;
mysql> grant all on cm_test.* to 'root' identified by 'xxx';
mysql> grant all on cm_test.* to 'cm'@'localhost' identified by 'cm';
mysql> grant all on cm_test.* to 'cm' identified by 'cm';

mysql> create database cm_production;
mysql> grant all on cm_production.* to 'root' identified by 'xxx';
mysql> grant all on cm_production.* to 'cm'@'localhost' identified by 'cm';
mysql> grant all on cm_production.* to 'cm' identified by 'cm';
```

Then confirm that the new databases are present.

```
mysql> show databases;
+---------------------+
| Database            |
+---------------------+
...
| cm_development    |
| cm_production     |
| cm_test           |
...
```

#### Run the Migrations and Seed the DB

Drop, create, migrate, and seed the databases.

```
$ ./reset_dbs.sh
```

Optionally create 50 dummy Contacts.

```
$ bundle exec rake data:add_contacts
```

#### Testing and Code Coverage

```
bundle exec rspec
bundle exec cucumber
```

View the SimpleCov reports file 'coverage/index.html' with your browser.
The code coverage percentage currently is 92.0%.

#### Run the Rails application

```
bundle exec rails s
```

#### TODO in the next sprint(s)

- Add pagination for the list of contacts.
- Image uploads, with ImageMagic daemon process to resize to two normalized sizes.
- Add an Address model, and one-to-many relationship for Contact -> Address.
- Consider making the app a single-page web app with Backbone.js and JSON services.
- JavaScipt testing, and JS generation with CoffeeScript.
