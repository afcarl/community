const mongoose = require('mongoose');

Student = new mongoose.Schema({
    classname: {
        type: String,
        index: false,
        "default": 'Student'
    },
    student_id: {
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

Student.statics.find_by_student_id = function(id, callback) {
    return this.findOne({student_id: id}, callback);
};

Student.statics.find_active = function(callback) {
    var limit = 1000;
    var query = this.find({state: 'active'});
    query.limit(limit);
    query.sort('course_id');
    return query.exec(callback);
};

module.exports = mongoose.model('Student', Student);
