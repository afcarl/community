const fs           = require('fs');
const util         = require('util');
const walk         = require('walk');
const EventEmitter = require('events');
const CsvParser    = require('./csv_parser').CsvParser;

function CsvProcessor() {
    var self = this;
    var files_list = null;
    var parse_results = null;

    this.process_files = function (list) {
        self.files_list = list;
        self.parse_results = [];
        self.parse_next_file(0);
    };

    this.parse_next_file = function (idx) {
        if (idx < self.files_list.length) {
            f = self.files_list[idx];
            p = new CsvParser();
            p.on('done', (evt_obj) => {
                if (evt_obj.data) {
                    self.parse_results.push(evt_obj.data);
                }
               self.parse_next_file(idx + 1);
            });
            p.parse(f);
        }
        else {
            f = 'data/csv_data.json';
            fs.writeFileSync('data/csv_data.json', JSON.stringify(self.parse_results, null, 2));
            console.log('merged file written: ' + f);
        }
    }
}

util.inherits(CsvProcessor, EventEmitter);

module.exports.CsvProcessor = CsvProcessor;
