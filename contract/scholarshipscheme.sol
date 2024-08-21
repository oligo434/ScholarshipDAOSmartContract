// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ScholarshipDAO {
    struct Applicant {
        string name;
        uint gpa;
        uint income;
        uint communityServiceHours;
        bool isApproved;
    }

    mapping(address => Applicant) public applicants;
    address[] public approvedApplicants;
    address public owner;

    uint public minimumGPA = 30; 
    uint public maximumIncome = 50000;
    uint public minimumCommunityService = 50; 

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function applyForScholarship(string memory _name, uint _gpa, uint _income, uint _communityServiceHours) public {
        require(_gpa >= minimumGPA, "GPA does not meet the minimum requirement");
        require(_income <= maximumIncome, "Income exceeds the maximum allowed");
        require(_communityServiceHours >= minimumCommunityService, "Community service hours do not meet the minimum requirement");

        applicants[msg.sender] = Applicant(_name, _gpa, _income, _communityServiceHours, false);
    }

    function approveApplicant(address _applicant) public onlyOwner {
        require(applicants[_applicant].gpa >= minimumGPA, "Applicant does not meet GPA criteria");
        require(applicants[_applicant].income <= maximumIncome, "Applicant does not meet income criteria");
        require(applicants[_applicant].communityServiceHours >= minimumCommunityService, "Applicant does not meet community service criteria");

        applicants[_applicant].isApproved = true;
        approvedApplicants.push(_applicant);
    }

    function distributeScholarship() public onlyOwner {
        uint totalFunds = address(this).balance;
        uint individualScholarshipAmount = totalFunds / approvedApplicants.length;

        for (uint i = 0; i < approvedApplicants.length; i++) {
            payable(approvedApplicants[i]).transfer(individualScholarshipAmount);
        }
    }

    receive() external payable {}
}
