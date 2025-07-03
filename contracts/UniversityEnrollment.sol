// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UniversityEnrollment {
    struct Course {
        string name;
        string code;
        uint maxStudents;
        uint enrolledCount;
        mapping(address => bool) enrolled;
    }

    mapping(uint => Course) public courses;
    uint public courseCount;

    event CourseCreated(uint courseId, string name, string code, uint maxStudents);
    event Enrolled(address student, uint courseId);

    function createCourse(string memory _name, string memory _code, uint _maxStudents) public {
        require(_maxStudents > 0, "Max students must be greater than 0");
        Course storage c = courses[courseCount];
        c.name = _name;
        c.code = _code;
        c.maxStudents = _maxStudents;
        c.enrolledCount = 0;
        emit CourseCreated(courseCount, _name, _code, _maxStudents);
        courseCount++;
    }

    function enroll(uint _courseId) public {
        require(_courseId < courseCount, "Course does not exist");
        Course storage c = courses[_courseId];
        require(!c.enrolled[msg.sender], "Already enrolled");
        require(c.enrolledCount < c.maxStudents, "Course is full");
        c.enrolled[msg.sender] = true;
        c.enrolledCount++;
        emit Enrolled(msg.sender, _courseId);
    }

    function isEnrolled(uint _courseId, address _student) public view returns (bool) {
        require(_courseId < courseCount, "Course does not exist");
        return courses[_courseId].enrolled[_student];
    }
}
