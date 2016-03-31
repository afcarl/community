const fs           = require('fs');
const CsvProcessor = require('./node/csv_processor').CsvProcessor;
const FilesLister  = require('./node/files_lister').FilesLister;
const Dao          = require('./node/models/dao').Dao;

if (process.argv.length < 3) {
    console.log('error: too few command-line args provided.');
    display_help();
    process.exit()
}

var funct = process.argv[2];

function display_help() {
    console.log('example commands:');
    console.log('  node main.js process_csv_files');
}

switch (funct) {

    case 'process_csv_files':
        var lister = new FilesLister();
        lister.list_files('data', '.csv');
        lister.on('done', (evt_obj) => {
            if (evt_obj.files) {
                var p = new CsvProcessor();
                p.process_files(evt_obj.files);
            }
        });
        break;

    case 'report':
        var dao = new Dao();
        dao.connect();
        dao.find_active_courses();
        break;

    default:
        console.log('error: unknown function - ' + funct);
        display_help();
}
