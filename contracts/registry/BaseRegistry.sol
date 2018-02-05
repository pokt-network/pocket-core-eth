pragma solidity ^0.4.11;

// This is the base contract that your contract PocketNodeRegistry extends from.
contract BaseRegistry {

    // The owner of this registry.
    address public owner = msg.sender;

    uint public creationTime = now;

    // TODO: Update both record structures with the new properties
    // This struct keeps all data for a Node Record.
    struct NodeRecord {
        // Keeps the address of this record creator.
        address owner;
        // Keeps the time when this record was created.
        uint time;
        // Keeps the index of the keys array for fast lookup
        uint keysIndex;
        string url;
    }

    // This struct keeps all data for a Oracle Record.
    struct OracleRecord {
        // Keeps the address of this record creator.
        address owner;
        // Keeps the time when this record was created.
        uint time;
        // Keeps the index of the keys array for fast lookup
        uint keysIndex;
        string url;
    }

    // List of registered Nodes
    address[] public registeredNodes;

    // List of registered Oracles
    address[] public registeredOracles;

    // This mapping keeps the records of this Registry.
    mapping(address => NodeRecord) nodeRecords;

    // This mapping keeps the records of this Registry.
    mapping(address => OracleRecord) oracleRecords;

    // Keeps the total numbers of Node records in this Registry.
    uint public numNodesRecords;

    // Keeps the total numbers of Oracle records in this Registry.
    uint public numOraclesRecords;

    // Keeps a list of all keys to iterate the Node records.
    address[] public nodeKeys;

    // Keeps a list of all keys to iterate the Oracle records.
    address[] public oracleKeys;

    modifier onlyOwner {
        if (msg.sender != owner) revert();
        _;
    }

    // This is the function that actually insert a record.
    function registerNodeRecord(address key, string[] _supportedTokens, string _url, uint8 _port, uint _index) {
        if (nodeRecords[key].time == 0) {
            nodeRecords[key].time = now;
            nodeRecords[key].owner = msg.sender;
            nodeRecords[key].keysIndex = nodeKeys.length;
            nodeKeys.length++;
            nodeKeys[nodeKeys.length - 1] = nodeKeys;
            nodeRecords[key].url = url;
            numNodesRecords++;
        } else {
          delete registeredNodes[index];
          // TODO: throw a more distinctive message
          revert();
        }
    }

    // This is the function that actually insert a record.
    function registerOracleRecord(address key, string[] _supportedTokens, string _url, uint8 _port, uint _index) {
        if (oracleRecords[key].time == 0) {
            oracleRecords[key].time = now;
            oracleRecords[key].owner = msg.sender;
            oracleRecords[key].keysIndex = oracleKeys.length;
            oracleKeys.length++;
            oracleKeys[oracleKeys.length - 1] = key;
            oracleRecords[key].url = url;
            numOraclesRecords++;
        } else {
          delete registeredOracles[index];
          // TODO: throw a more distinctive message
          revert();
        }
    }

    // Updates the values of the given Node record.
    function updateNode(address key, string url) {
        // Only the owner can update his record.
        if (nodeRecords[key].owner == msg.sender) {
            nodeRecords[key].url = url;
        }
    }

    // Updates the values of the given Oracle record.
    function updateOracle(address key, string url) {
        // Only the owner can update his record.
        if (oracleRecords[key].owner == msg.sender) {
            oracleRecords[key].url = url;
        }
    }

    // Unregister a given Node record
    function unregisterNode(address key) {
        if (nodeRecords[key].owner == msg.sender) {
            uint keysIndex = nodeRecords[key].keysIndex;
            delete nodeRecords[key];
            numNodesRecords--;
            nodeKeys[keysIndex] = nodeKeys[nodeKeys.length - 1];
            nodeRecords[nodeKeys[keysIndex]].keysIndex = keysIndex;
            nodeKeys.length--;
        }
    }

    // Unregister a given Oracle record
    function unregisterOracle(address key) {
        if (oracleRecords[key].owner == msg.sender) {
            uint keysIndex = oracleRecords[key].keysIndex;
            delete oracleRecords[key];
            numOraclesRecords--;
            oracleKeys[keysIndex] = oracleKeys[oracleKeys.length - 1];
            oracleRecords[oracleKeys[keysIndex]].keysIndex = keysIndex;
            oracleKeys.length--;
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

    // Tells whether a given Node key is registered.
    function isRegisteredNode(address key) returns(bool) {
        return nodeRecords[key].time != 0;
    }

    // Tells whether a given Oracle key is registered.
    function isRegisteredOracle(address key) returns(bool) {
        return oracleRecords[key].time != 0;
    }

    function getNodeRecordAtIndex(uint rindex) returns(address key, address owner, uint time, string url) {
        Record record = nodeRecords[nodeKeys[rindex]];
        key = nodeKeys[rindex];
        owner = record.owner;
        time = record.time;
        url = record.url;
    }

    function getOracleRecordAtIndex(uint rindex) returns(address key, address owner, uint time, string url) {
        Record record = oracleRecords[keys[rindex]];
        key = oracleKeys[rindex];
        owner = record.owner;
        time = record.time;
        url = record.url;
    }

    function getNodeRecord(address key) returns(address owner, uint time, string url) {
        Record record = nodeRecords[key];
        owner = record.owner;
        time = record.time;
        url = record.url;
    }

    function getOracleRecord(address key) returns(address owner, uint time, string url) {
        Record record = oracleRecords[key];
        owner = record.owner;
        time = record.time;
        url = record.url;
    }

    // Returns the owner of the given record. The owner could also be get
    // by using the function getRecord but in that case all record attributes
    // are returned.
    function getNodeOwner(address key) returns(address) {
        return nodeRecords[key].owner;
    }

    function getOracleOwner(address key) returns(address) {
        return oracleRecords[key].owner;
    }

    // Returns the registration time of the given record. The time could also
    // be get by using the function getRecord but in that case all record attributes
    // are returned.
    function getNodeTime(address key) returns(uint) {
        return nodeRecords[key].time;
    }

    function getOracleTime(address key) returns(uint) {
        return oracleRecords[key].time;
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
