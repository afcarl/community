const mongoose = require('mongoose');

Enrollment = new mongoose.Schema({
    classname: {
        type: String,
        index: false,
        "default": 'Enrollment'
    },
    course_id: {
        type: String,
        index: true
    },
    student_id: {
        type: String,
        index: true
    },
    state: {
        type: String,
        index: true
    }
});

Enrollment.statics.find_by_course_id = function(id, callback) {
    var limit = 5000;
    var query = this.find({course_id: id});
    query.limit(limit);
    query.sort('student_id');
    return query.exec(callback);
};

Enrollment.statics.find_active = function(callback) {
    var limit = 1000;
    var query = this.find({state: 'active'});
    query.limit(limit);
    query.sort('course_id');
    return query.exec(callback);
};

module.exports = mongoose.model('Enrollment', Enrollment);
