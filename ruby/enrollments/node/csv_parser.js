const fs           = require('fs');
const EventEmitter = require('events');
const util         = require('util');
const csv          = require('csv');

function CsvParser() {
    var self = this;

    this.parse = function (infile) {
        console.log('CsvParser.parse file: ' + infile);
        var parser = csv.parse({delimiter: ','}, function(err, data) {
            var result = {};
            result['err']  = err;
            result['data'] = data;
            self.emit('done', result);
        });
        fs.createReadStream(infile).pipe(parser);
    };
}

util.inherits(CsvParser, EventEmitter);

module.exports.CsvParser = CsvParser;
