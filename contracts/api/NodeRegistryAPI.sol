pragma solidity ^0.4.18;

import "./BaseAPI.sol";
import "../interfaces/NodeRegistry.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract NodeRegistryAPI is BaseAPI, NodeRegistry {
    // Events
    event NodeRegistered(address _owner, bytes32 _nonce, bytes8[] _networks, string _endpoint);

    // Functions
    /*
     * @dev allows to register a new Node, returning a bytes32 nonce for the Node, if it doesn't exist already, in which case it will error out.
     * @param bytes8[] _networks - List of networks this Node supports (BTC, ETH, etc.).
     * @param string _endpoint - The endpoint information in multi addr format.
     */
    function register(bytes8[] _networks, string _endpoint) public returns(bytes32) {
        bytes32 nodeNonce = keccak256(_networks, _endpoint, msg.sender, nodesPerAccount[msg.sender].length);
        nodes[nodeNonce] = Models.Node(nodeNonce, msg.sender, _networks, _endpoint);
        nodesIndex.push(nodeNonce);
        nodesPerAccount[msg.sender].push(nodeNonce);
        NodeRegistered(msg.sender, nodeNonce, _networks, _endpoint);
        return nodeNonce;
    }

    /*
     * @dev Verify existence of a given Node nonce
     * @param bytes32 _nodeNonce - Nonce to verify against.
     */
    function isNode(bytes32 _nodeNonce) public view returns(bool) {
        return nodes[_nodeNonce].nonce != bytes32(0);
    }

    /*
     * @dev Verify ownership of a given Node.
     * @param address _possibleOwner - The possible owner of the given node we want to verify
     * @param bytes32 _nodeNonce - The nonce of the Node we want to verify
     */
    function isOwner(address _possibleOwner, bytes32 _nodeNonce) public view returns(bool) {
        return nodes[_nodeNonce].owner == _possibleOwner;
    }

    /*
     * @dev Returns the owner of the node
     * @param bytes32 _nodeNonce
     */
    function getNodeOwner(bytes32 _nodeNonce) public view returns(address) {
        return nodes[_nodeNonce].owner;
    }

    /*
     * @dev Returns a paginated list of the nodes owned by the account
     * @param address _owner
     * @param uint256 _page
     */
    function getOwnerNodes(address _owner, uint256 _page) public view returns (bytes32[]) {
        uint256 totalNodes = uint256(nodesPerAccount[_owner].length);
        bytes32[] memory result = new bytes32[](10);
        if(totalNodes > 0 && _page > 0){
            uint256 initialIndex = SafeMath.mul(uint256(SafeMath.sub(_page, 1)), 10);
            uint256 lastIndex = SafeMath.add(initialIndex, 9);
            if(initialIndex < totalNodes) {
                uint256 resultIndex = 0;
                for(uint256 i = initialIndex; i < lastIndex; i++){
                    if(i < totalNodes){
                        result[resultIndex] = bytes32(nodesPerAccount[_owner][i]);
                    } else {
                        result[resultIndex] = bytes32(0);
                    }
                    resultIndex = SafeMath.add(resultIndex, 1);
                }
            }
        }
        return result;
    }

    /*
     * @dev Returns the Node information given the nonce
     * @param bytes32 _nodeNonce
     */
    function getNode(bytes32 _nodeNonce) public view returns (bytes32, address, bytes8[], string) {
        return(nodes[_nodeNonce].nonce, nodes[_nodeNonce].owner, nodes[_nodeNonce].networks, nodes[_nodeNonce].endpoint);
    }

    /*
     * @dev Returns the length of the nodesIndex array
     */
    function getNodesIndexLength() public view returns (uint256) {
        return nodesIndex.length;
    }
}
