const mongoose = require('mongoose');

Course = new mongoose.Schema({
    classname: {
        type: String,
        index: false,
        "default": 'Course'
    },
    course_id: {
        type: String,
        index: true
    },
    name: {
        type: String,
        index: true
    },
    state: {
        type: String,
        index: true
    }
});

Course.statics.find_by_course_id = function(id, callback) {
    return this.findOne({course_id: id}, callback);
};

Course.statics.find_active = function(callback) {
    var limit = 1000;
    var query = this.find({state: 'active'});
    query.limit(limit);
    query.sort('course_id');
    return query.exec(callback);
};

module.exports = mongoose.model('Course', Course);
