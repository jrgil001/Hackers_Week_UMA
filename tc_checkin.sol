pragma solidity >=0.4.22 <0.6.0;

contract tc_checkin {
    
    address internal owner;
    
    struct Passenger {
        address account;
        string name;
        string origin;
        string destination;
        uint numberBags;
    }
    
    struct Bag {
        address account;
        string bagType;
        string location;
    }
    
    mapping(address => Passenger) internal passengers;
    mapping(address => Bag []) internal passBags;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function registerPassenger (string memory name, string memory origin, string memory destination, uint numberBags) public {
        Passenger storage passenger = passengers[msg.sender];
        passenger.account = msg.sender;
        passenger.name = name;
        passenger.origin = origin;
        passenger.destination = destination;
        passenger.numberBags = numberBags;
    }
    	
    function getPassenger () public view returns (string name, string origin, string destination, uint numberBags){
        Passenger passenger = passengers[msg.sender];
        return (passenger.name, passenger.origin, passenger.destination, passenger.numberBags);
    }
    	
    function checkinPassenger (uint numberBags) public payable{
        require(numberBags == 1 && msg.value == 0 ether || numberBags > 1 && msg.value == 3 ether);
        Passenger storage passenger = passengers[msg.sender];
        passenger.numberBags = numberBags;
        owner.transfer(msg.value);
    }
    
    function registerBag (string memory bagType, string memory location) public {
        passBags[msg.sender].push(Bag(msg.sender, bagType, location));
    }
    
    function getBags () public view returns (string bagType, string location){
        Bag [] storage bags = passBags[msg.sender];
        string memory bagTypes = new string(1);
        string memory bagLocations = new string(1);
        uint numberBags = bags.length;
        
        
        for (uint i=0; i<numberBags; i++) {
            bagTypes = strConcat(bagTypes, ";", bags[i].bagType);
            bagLocations = strConcat(bagLocations, ";", bags[i].location);
        }

        return (bagTypes, bagLocations);
    }
    
    function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){ 
        bytes memory _ba = bytes(_a); 
        bytes memory _bb = bytes(_b); 
        bytes memory _bc = bytes(_c); 
        bytes memory _bd = bytes(_d); 
        bytes memory _be = bytes(_e); 
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length); 
        bytes memory babcde = bytes(abcde); 
        uint k = 0; 
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i]; 
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i]; 
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i]; 
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i]; 
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i]; 
        return string(babcde); 
    }

    function strConcat(string _a, string _b, string _c, string _d) internal returns (string) { 
        return strConcat(_a, _b, _c, _d, ""); 
    }
    
    function strConcat(string _a, string _b, string _c) internal returns (string) { 
        return strConcat(_a, _b, _c, "", ""); 
    }
    
    function strConcat(string _a, string _b) internal returns (string) { 
        return strConcat(_a, _b, "", "", ""); 
    }
}
