//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "hardhat/console.sol";

library StakeLib {

    event Rewarded(address staker, uint256 amount);

    function bal(address query, address minter) internal view returns (uint16){
        return uint16(IERC721(minter).balanceOf(query));
    }

    function owns(uint256 tokenID,address minter) internal view {
        address owner = ownerOf(tokenID, minter);
        // console.log("Sender " , msg.sender);
        // console.log("Owner ", owner);
        require(msg.sender == owner , "Err");
    }

    function ownsMul(uint256[] memory tokenIDs, address minter) internal view {
        for(uint8 i =0; i< tokenIDs.length; i++){
            require(ownerOf(tokenIDs[i], minter) == msg.sender, "Err");
        }
    }

    function ownerOf(uint256 tokenId, address minter) internal view returns(address) {
        return IERC721(minter).ownerOf(tokenId);
    }

    function getApprovalForOne(uint256 tokenId, address minter) internal {
        IERC721(minter).approve(address(this), tokenId);
    }

    function getApprovalForMul(uint256[] memory tokenIds, address minter) internal {
        for(uint8 i = 0; i< tokenIds.length; i++){
            IERC721(minter).approve(address(this), tokenIds[i]);
        }
    }

    function bringHere(uint256 tokenId, address minter) internal {
        IERC721(minter).safeTransferFrom(ownerOf(tokenId, minter), address(this), tokenId);
    }

    function bringHereMul(uint256[] memory tokenIds, address minter) internal {
        for(uint8 i = 0; i< tokenIds.length; i++){
            IERC721(minter).safeTransferFrom(ownerOf(tokenIds[i], minter), address(this), tokenIds[i]);
        }
    }

    function sendBack(uint256 tokenId, address minter, address to) internal {
        IERC721(minter).safeTransferFrom(address(this), to, tokenId);
    }

    function sendBackMul(uint256[] memory tokenIds, address minter, address to) internal {
        for(uint8 i = 0; i< tokenIds.length; i++){
            IERC721(minter).safeTransferFrom(address(this), to, tokenIds[i]);
        }
    }

    function removeApprovalForOne(uint256 tokenId, address minter) internal {
        IERC721(minter).approve(address(0x0), tokenId);
    }

    function removaApprovalForMul(uint256[] memory tokenIds, address minter) internal {
        for(uint8 i = 0; i< tokenIds.length; i++){
            IERC721(minter).approve(address(0x0), tokenIds[i]);
        }
    }

    function calculate(uint256 reward, uint256 noOfBlocks) internal pure returns(uint256){
        return reward * noOfBlocks;
    }

    function payout(address to, uint256 amount, address g4n9, address from) internal {
        IERC20(g4n9).transferFrom(from, to, amount); 
        emit Rewarded(to, amount);   
    }
} 