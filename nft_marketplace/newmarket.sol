// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./newnft.sol";

contract Market {
  uint public offerCount;
  mapping (uint => _Offer) public offers;
  mapping (address => uint) public userFunds;
  NFTAmit nftCAmit;
  
  struct _Offer {
    uint offerId;
    uint id;
    address user;
    uint price;
    bool fulfilled;
    
  }

  event Offer(uint offerId, uint id, address user, uint price, bool fulfilled);
  event OfferFilled(uint offerId, uint id, address newOwner);
  event ClaimFunds(address user, uint amount);
  

  constructor(address _nftAmit) {
    nftCAmit = NFTAmit(_nftAmit);
  }
  
  function makeOffer(uint _id, uint _price) public {
    nftCAmit.transferFrom(msg.sender, address(this), _id);
    offerCount ++;
    offers[offerCount] = _Offer(offerCount, _id, msg.sender, _price, false);
    emit Offer(offerCount, _id, msg.sender, _price, false);
  }

  function fillOffer(uint _offerId) public payable {
      
    _Offer storage _offer = offers[_offerId];
    require(_offer.offerId == _offerId, 'The offer must exist');
    require(_offer.user != msg.sender, 'The owner of the offer cannot fill it');
    require(!_offer.fulfilled, 'An offer cannot be fulfilled twice');
    require(msg.value == _offer.price, 'The ETH amount should match with the NFT Price');
    nftCAmit.transferFrom(address(this), msg.sender, _offer.id);
    _offer.fulfilled = true;
    userFunds[_offer.user] += msg.value;
    emit OfferFilled(_offerId, _offer.id, msg.sender);
  }

    


  function claimFunds() public {
    require(userFunds[msg.sender] > 0, 'This user has no funds to be claimed');
    payable(msg.sender).transfer(userFunds[msg.sender]);
    emit ClaimFunds(msg.sender, userFunds[msg.sender]);
    userFunds[msg.sender] = 0;    
  }

  // Fallback: reverts if Ether is sent to this smart-contract by mistake
  fallback () external {
    revert();
  }

  
}