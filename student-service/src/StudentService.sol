// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract StudentService {
    string[] private exams;
    mapping(address => bool) private users;
    mapping(address => string[]) private professorExamResults;
    mapping(address => string[]) private studentExamResults;

    event examRegistered(address indexed student, string indexed examResult);
    event examGraded(string indexed examResult, uint256 indexed grade);

    constructor(
        address[] memory _professors,
        address[] memory _students,
        string[] memory _exams
    ) {
        require(
            !duplicateExistBetweenAddressArrays(_professors, _students),
            "An addresses with the same value can be found in both professors and students array"
        );
        require(
            !duplicateExistInStringArray(_exams),
            "Array of exams contains duplicates"
        );
        for (uint256 i = 0; i < _professors.length; i++) {
            users[_professors[i]] = true;
        }
        for (uint256 i = 0; i < _students.length; i++) {
            users[_students[i]] = true;
        }
        exams = _exams;
    }

    function valueExistInStringArray(
        string[] memory arr,
        string memory _value
    ) private pure returns (bool) {
        if (arr.length < 1) return false;
        for (uint256 i = 0; i < arr.length; i++)
            if (
                keccak256(abi.encodePacked(arr[i])) ==
                keccak256(abi.encodePacked(_value))
            ) return true;
        return false;
    }

    function duplicateExistBetweenAddressArrays(
        address[] memory arr1,
        address[] memory arr2
    ) private pure returns (bool) {
        if (arr1.length < 1 || arr2.length < 1) return false;
        for (uint256 i = 0; i < arr1.length; i++)
            for (uint256 j = 0; j < arr2.length; j++)
                if (
                    keccak256(abi.encodePacked(arr1[i])) ==
                    keccak256(abi.encodePacked(arr2[j]))
                ) return true;
        return false;
    }

    function duplicateExistInStringArray(
        string[] memory arr
    ) private pure returns (bool) {
        if (arr.length < 1) return false;
        for (uint256 i = 0; i < arr.length - 1; i++)
            for (uint256 j = i + 1; j < arr.length; j++)
                if (
                    keccak256(abi.encodePacked(arr[i])) ==
                    keccak256(abi.encodePacked(arr[j]))
                ) return true;
        return false;
    }

    function getUser(address _addr) public view returns (bool) {
        return users[_addr];
    }

    function getExams() public view returns (string[] memory) {
        return exams;
    }

    function getExamResults(
        address _user,
        bool _isProfessor
    ) public view returns (string[] memory) {
        if (_isProfessor) return professorExamResults[_user];
        return studentExamResults[_user];
    }

    function registerExam(
        address _professor,
        string memory _examResult
    ) public payable {
        require(
            getUser(_professor),
            "Professor with that address does not exist"
        );
        require(
            getUser(msg.sender),
            "Student with that address does not exist"
        );
        require(
            !valueExistInStringArray(
                studentExamResults[msg.sender],
                _examResult
            ),
            "This exam result already exists for user"
        );
        require(
            !valueExistInStringArray(
                professorExamResults[_professor],
                _examResult
            ),
            "This exam result already exists for professor"
        );
        require(msg.value > 0.0000055 ether, "Insufficient funds were sent");

        studentExamResults[msg.sender].push(_examResult);
        professorExamResults[_professor].push(_examResult);

        emit examRegistered(msg.sender, _examResult);
    }

    function gradeExam(string memory _examResult, uint8 _grade) public {
        require(
            getUser(msg.sender),
            "Professor with that address does not exist"
        );
        require(
            valueExistInStringArray(
                professorExamResults[msg.sender],
                _examResult
            ),
            "This exam result does not exists for professor"
        );
        require(_grade > 4 && _grade < 11, "Grade must be between 5 and 10");

        emit examGraded(_examResult, _grade);
    }
}
