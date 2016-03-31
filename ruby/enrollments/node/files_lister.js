const fs           = require('fs');
const path         = require('path');
const util         = require('util');
const walk         = require('walk');
const EventEmitter = require('events');

// see https://www.npmjs.com/package/walk

function FilesLister() {
    var self = this;

    this.list_files = function (dir, suffix) {
        var files  = [];
        var errors = 0;

        console.log('FilesLister.list_files; dir: ' + dir + ' suffix: ' + suffix);
        var walker = walk.walk(dir);

        walker.on("file", function (root, fileStats, next) {
            var filename = fileStats.name;
            if (filename.endsWith(suffix)) {
              files.push(dir + path.sep + fileStats.name);
            }
            next();
        });

        walker.on("errors", function (root, nodeStatsArray, next) {
            errors = errors + 1;
            next();
        });

        walker.on("end", function () {
            var evt_obj = {};
            evt_obj['errors'] = errors;
            evt_obj['files']  = files;
            self.emit('done', evt_obj);
        });
    };
}

util.inherits(FilesLister, EventEmitter);

module.exports.FilesLister = FilesLister;
