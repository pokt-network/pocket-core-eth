pragma solidity ^0.4.11;

// This is the base contract that your contract PocketNodeRegistry extends from.
contract BaseRegistry {

    // The owner of this registry.
    address public owner = msg.sender;

    uint public creationTime = now;

    // This struct keeps all data for a Record.
    struct Record {
        // Keeps the address of this record creator.
        address owner;
        // Keeps the time when this record was created.
        uint time;
        // Keeps the index of the keys array for fast lookup
        uint keysIndex;
        string url;
    }

    // This mapping keeps the records of this Registry.
    mapping(address => Record) records;

    // Keeps the total numbers of records in this Registry.
    uint public numRecords;

    // Keeps a list of all keys to interate the records.
    address[] public keys;


    modifier onlyOwner {
        if (msg.sender != owner) revert();
        _;
    }



    // This is the function that actually insert a record.
    function register(address key, string url) {
        if (records[key].time == 0) {
            records[key].time = now;
            records[key].owner = msg.sender;
            records[key].keysIndex = keys.length;
            keys.length++;
            keys[keys.length - 1] = key;
            records[key].url = url;
            numRecords++;
        } else {
            // TODO: throw a more distinctive message
            revert();
        }
    }

    // Updates the values of the given record.
    function update(address key, string url) {
        // Only the owner can update his record.
        if (records[key].owner == msg.sender) {
            records[key].url = url;
        }
    }

    // Unregister a given record
    function unregister(address key) {
        if (records[key].owner == msg.sender) {
            uint keysIndex = records[key].keysIndex;
            delete records[key];
            numRecords--;
            keys[keysIndex] = keys[keys.length - 1];
            records[keys[keysIndex]].keysIndex = keysIndex;
            keys.length--;
        }
    }

    // Transfer ownership of a given record.
    function transfer(address key, address newOwner) {
        if (records[key].owner == msg.sender) {
            records[key].owner = newOwner;
        } else {
            revert();
        }
    }

    // Tells whether a given key is registered.
    function isRegistered(address key) returns(bool) {
        return records[key].time != 0;
    }

    function getRecordAtIndex(uint rindex) returns(address key, address owner, uint time, string url) {
        Record record = records[keys[rindex]];
        key = keys[rindex];
        owner = record.owner;
        time = record.time;
        url = record.url;
    }

    function getRecord(address key) returns(address owner, uint time, string url) {
        Record record = records[key];
        owner = record.owner;
        time = record.time;
        url = record.url;
    }

    // Returns the owner of the given record. The owner could also be get
    // by using the function getRecord but in that case all record attributes
    // are returned.
    function getOwner(address key) returns(address) {
        return records[key].owner;
    }

    // Returns the registration time of the given record. The time could also
    // be get by using the function getRecord but in that case all record attributes
    // are returned.
    function getTime(address key) returns(uint) {
        return records[key].time;
    }

    // Registry owner can use this function to withdraw any value owned by
    // the registry.
    function withdraw(address to, uint value) onlyOwner {
        if (!to.send(value)) revert();
    }

    function kill() onlyOwner {
        suicide(owner);
    }
}
