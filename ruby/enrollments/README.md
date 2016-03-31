# enrollments

Some fun with Rails and CSV files.

### Execution

- execute bash shell script "execute.sh".  
- then see the generated reports in the tmp/ directory.

### Testing

- rake spec
- then visit file coverage/index.html with your browser for code coverage reporting.

### Rails Generators

- rails new enrollments --database=sqlite3 --skip-test-unit
- rails generate rspec:install
- rails g model course course_id:string course_name:string state:string
- rails g model student user_id:string user_name:string state:string
- rails g model enrollment course_id:string user_id:string state:string

### Lessons Learned

- Unset the DATABASE_URL environment variable on your computer!
  You may have set this when working on previous Python/Django apps;
  its presence will override the Rails database.yml config.
- Translate csv column names to model attribute names for better ActiveRecord associations.
  For example, use 'student_id' rather than 'user_id'.

### But wait, there's more

- Started implementing similar functionality with Node.js, in this same repo, on 3/21.
- Install node.js on your system.
- Run 'npm install' in the project root to install the libraries specified in package.json.
- Run 'node main.js process_csv_files' to parse the csv files into merged file data/csv_data.json
- The rest is currently work-in-progress.

