// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import {IEIP1271Implementer} from '../interfaces/IEIP1271Implementer.sol';

// todo: should receive 65 length bytes and decode manually.
contract MockEIP1271Implementer is IEIP1271Implementer {
    // bytes4(keccak256("isValidSignature(bytes32,bytes)")
    bytes4 internal constant MAGIC_VALUE = 0x1626ba7e;

    address public immutable OWNER;

    constructor() {
        OWNER = msg.sender;
    }

    function isValidSignature(bytes32 _hash, bytes memory _signature)
        external
        view
        override
        returns (bytes4)
    {
        require(_signature.length == 65, 'Invalid signature length');
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := shr(248, mload(add(_signature, 96)))
        }

        // (bytes32 r, bytes32 s, uint8 v) = abi.decode(_signature, (bytes32, bytes32, uint8));
        address signer = ecrecover(
            keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n32', _hash)),
            v,
            r,
            s
        );
        require(signer != address(0), 'Invalid recovery');
        return signer == OWNER ? MAGIC_VALUE : bytes4(0xFFFFFFFF);
    }
}
