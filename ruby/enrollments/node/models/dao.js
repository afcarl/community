const mongoose     = require('mongoose');
const EventEmitter = require('events');
const util         = require('util');
const Course       = require('./course_schema.js').Course;
const Enrollment   = require('./course_schema.js').Enrollment;
const Student      = require('./course_schema.js').Student;

function Dao() {
    var self = this;
    var connection = null;

    this.connect = function () {
        console.log('TODO - implement logic to connect to MongoDB')
    };

    this.find_active_courses = function () {
        console.log('TODO - implement the Dao')
    };
}

util.inherits(Dao, EventEmitter);

module.exports.Dao = Dao;
