pragma solidity ^0.4.11;

// This is the base contract that your contract PocketNodeRegistry extends from.
contract BaseRegistry is NodeCrud {

    // The owner of this registry.
    address public owner = msg.sender;

    uint public creationTime = now;

    // List of registered Nodes
    address[] public registeredNodes;

    // This mapping keeps the records of this Registry.
    mapping(address => Node) nodeRecords;

    // Keeps the total numbers of Node records in this Registry.
    uint public numNodeRecords;

    // Keeps a list of all keys to iterate the Node records.
    address[] public nodeKeys;

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
            numNodeRecords++;
        } else {
          delete registeredNodes[index];
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

    // Unregister a given Node record
    function unregisterNode(address key) {
        if (nodeRecords[key].owner == msg.sender) {
            uint keysIndex = nodeRecords[key].keysIndex;
            delete nodeRecords[key];
            numNodeRecords--;
            nodeKeys[keysIndex] = nodeKeys[nodeKeys.length - 1];
            nodeRecords[nodeKeys[keysIndex]].keysIndex = keysIndex;
            nodeKeys.length--;
        }
    }

    // Transfer ownership of a given record.
    function transfer(address key, address newOwner) {
        if (nodeRecords[key].owner == msg.sender) {
            nodeRecords[key].owner = newOwner;
        } else {
            revert();
        }
    }

    // Tells whether a given Node key is registered.
    function isRegisteredNode(address key) returns(bool) {
        return nodeRecords[key].time != 0;
    }

    function getNodeRecordAtIndex(uint rindex) returns(address key, address owner, uint time, string url) {
        Record record = nodeRecords[nodeKeys[rindex]];
        key = nodeKeys[rindex];
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

    // Returns the owner of the given record. The owner could also be get
    // by using the function getRecord but in that case all record attributes
    // are returned.
    function getNodeOwner(address key) returns(address) {
        return nodeRecords[key].owner;
    }

    // Returns the registration time of the given record. The time could also
    // be get by using the function getRecord but in that case all record attributes
    // are returned.
    function getNodeTime(address key) returns(uint) {
        return nodeRecords[key].time;
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
