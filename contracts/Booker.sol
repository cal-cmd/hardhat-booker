pragma solidity 0.8.0;

contract Booker {

    struct Room {
        mapping(uint => uint) reservationsByHour;
        mapping(uint => bool) reservedHours;
        string company;
    }

    struct Reservation {
        address booker;
        uint hour;
        uint room;
        string company;
        bool reserved;
    }

    event Booked(address partner, uint indexed room, uint hour, string indexed company);
    event Cancelled(address partner, string indexed company);

    mapping(string => mapping(uint => Room)) internal _rooms;
    mapping(address => Reservation) internal _reservations;

    constructor(string memory companyOne, string memory companyTwo) {
        for (uint c = 1; c <= 10; c++) {
            _rooms[companyOne][c].company = companyOne;
            _rooms[companyTwo][c].company = companyTwo;
        }
    }

    function book(uint room, uint hour, string memory company) public {
        string memory requestedRoom = _rooms[company][room].company;

        require(!_reservations[msg.sender].reserved, "Already booked for another room");
        require(!_rooms[company][room].reservedHours[hour], "Room already booked");
        require(keccak256(abi.encodePacked(company)) == keccak256(abi.encodePacked(requestedRoom)), "Company/room not found");
        require(hour <= 20 && hour >= 8, "Please book between the hours of: 8-20");

        _rooms[company][room].reservationsByHour[hour] += 1;
        _rooms[company][room].reservedHours[hour] = true;

        _reservations[msg.sender].booker = msg.sender;
        _reservations[msg.sender].hour = hour;
        _reservations[msg.sender].room = room;
        _reservations[msg.sender].company = company;
        _reservations[msg.sender].reserved = true;

        emit Booked(msg.sender, room, hour, company);
    }

    function cancel() public {
        require(_reservations[msg.sender].reserved, "Reservation not booked");

        string memory company = _reservations[msg.sender].company;

        _reservations[msg.sender].hour = 0;
        _reservations[msg.sender].reserved = false;
        _reservations[msg.sender].room = 0;
        _reservations[msg.sender].booker = address(0);
        _reservations[msg.sender].company = "";

        emit Cancelled(msg.sender, company);
    }

    function isRoomAvailable(uint room, uint hour, string memory company) public view returns(bool) {
        require(hour <= 20 && hour >= 8, "Availability between the hours of: 8-20");
        require(room <= 10 && room >= 1, "Availability between rooms: 1-10");

        if (!_rooms[company][room].reservedHours[hour] && keccak256(abi.encodePacked(company)) == keccak256(abi.encodePacked(_rooms[company][room].company))) {
            return true;
        } else {
            return false;
        }
    }
}