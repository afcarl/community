
"P3" - a simple "hello world" project using Python 3, Django, and MySQL


System Configuration - python, python3 and mysql installed on OS X with Homebrew

- which python         => /usr/local/bin/python
- which python3        => /usr/local/bin/python3
- which pip            => /usr/local/bin/pip
- which pip3           => /usr/local/bin/pip3
- which virtualenv     => /usr/local/bin/virtualenv
- python --version     => Python 2.7.6
- python3 --version    => Python 3.3.4
- virtualenv --version => 1.11.2
- mysql --version      => mysql  Ver 14.14 Distrib 5.6.16, for osx10.9 (x86_64) using  EditLine wrapper


Virtualenv Creation:

- cd /Users/cjoakim/github/cjoakim/python
- mkdir p3
- cd p3
- virtualenv --python=/usr/local/bin/python3 p3  =>
    Running virtualenv with interpreter /usr/local/bin/python3
    Using base prefix '/usr/local/Cellar/python3/3.3.4/Frameworks/Python.framework/Versions/3.3'
    New python executable in p3/bin/python3.3
    Also creating executable in p3/bin/python
    Installing setuptools, pip...done.

- source p3/bin/activate
- python --version  =>  Python 3.3.4   (python version is now 3.3.4 per the virtualenv)
- pip install --upgrade pip
- pip install --upgrade setuptools
- pip install PyMySQL
- pip install Django==1.6.2
- pip list  =>
    Django (1.6.2)
    pip (1.5.2)
    PyMySQL (0.6.1)
    setuptools (2.2)

- python -c "import django; print(django.get_version())" => 1.6.2


MySQL Database Creation:

  mysql> create database c3;
  mysql> grant all on c3.* to 'c3user' identified by 'c3pass';
  mysql> grant all on c3.* to 'c3user'@'localhost' identified by 'c3pass';
  mysql> use c3;


Django App Creation:

- django-admin.py startproject c3
- cd c3

- edit settings.py to point to the mysql database:

    DATABASES = {
        'default': {
            'ENGINE':   'django.db.backends.mysql',
            'NAME':     'c3',
            'USER':     'c3user',
            'PASSWORD': 'c3pass',
            'HOST':     'localhost',   # Or an IP Address that your DB is hosted on
            'PORT':     '3306',
        }
    }

- edit manage.py to use the PyMySQL driver

    try:
        import pymysql
        pymysql.install_as_MySQLdb()
    except ImportError:
        pass

- python manage.py syncdb  =>
    Creating tables ...
    Creating table django_admin_log
    Creating table auth_permission
    Creating table auth_group_permissions
    Creating table auth_group
    Creating table auth_user_groups
    Creating table auth_user_user_permissions
    Creating table auth_user
    Creating table django_content_type
    Creating table django_session

    You just installed Django's auth system, which means you don't have any superusers defined.
    Would you like to create one now? (yes/no): yes
    Username (leave blank to use 'cjoakim'):
    Email address: cjoakim@bellsouth.net
    Password:
    Password (again):
    Superuser created successfully.
    Installing custom SQL ...
    Installing indexes ...
    Installed 0 object(s) from 0 fixture(s)


- python manage.py runserver

- visit http://localhost:8000 with your browser, and see:
    It worked!
    Congratulations on your first Django-powered page.

- Control-C, stop the python server process.  Let's now add a model.

- Create the 'weather' app with in the 'c3' project

  python manage.py startapp weather

- Edit the models.py file in the weather app, add class WeatherCondition

    class WeatherCondition(models.Model):
        name = models.CharField(max_length=20)

- python manage.py syncdb

- mysql> describe weather_weathercondition;
    +-------+-------------+------+-----+---------+----------------+
    | Field | Type        | Null | Key | Default | Extra          |
    +-------+-------------+------+-----+---------+----------------+
    | id    | int(11)     | NO   | PRI | NULL    | auto_increment |
    | name  | varchar(20) | NO   |     | NULL    |                |
    +-------+-------------+------+-----+---------+----------------+

  mysql> INSERT INTO `weather_weathercondition` VALUES (1, 'Sunshine');
  mysql> INSERT INTO `weather_weathercondition` VALUES (2, 'Wind');
  mysql> INSERT INTO `weather_weathercondition` VALUES (3, 'Rain');
  mysql> INSERT INTO `weather_weathercondition` VALUES (4, 'Snow');

  mysql> select * from weather_weathercondition;
    +----+----------+
    | id | name     |
    +----+----------+
    |  1 | Sunshine |
    |  2 | Wind     |
    |  3 | Rain     |
    |  4 | Snow     |
    +----+----------+

- edit the weather/admin.py file to support the WeatherCondition model, by adding:

    from weather.models import WeatherCondition
    admin.site.register(WeatherCondition)

- python manage.py runserver

- visit http://localhost:8000/admin/ with your browser
  Use the credentials from the initial 'python manage.py syncdb'

  See that the WeatherModel, and its 4 rows, are present and editable


