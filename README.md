# ERC721 NFT Marketplace
Solidity Contracts of simple NFT Mint and Marketplace based on openZeppelin ERC721 contracts.


### Dependencies
This project relies on openZeppelin ERC721 contracts.


### Tech-Stack
 -  Solidity
 -  openZeppelin
 -  Metamask (web3)
 -  remix IDE

### Functionalities

#### Mint
The user must input _tokenURI to mint his own NFT. Once minted,  it will be owned by its creator. 

##### Function used in Mint NFT
 ```
function safeMint(string memory _tokenURI) public {
    require(!_tokenURIExists[_tokenURI], 'The token URI should be unique');
    tokenURIs.push(_tokenURI);    
    uint _id = tokenURIs.length;
    _tokenIdToTokenURI[_id] = _tokenURI;
    _safeMint(msg.sender, _id);                      // it's defination wtitten in ERC721 And used for mint NFT 
    _tokenURIExists[_tokenURI] = true;
  }
 ```

##### Make Offer

The user can offer his NFT by specifying its price (in Ether). If someone fulfills this offer, then the ownership is transferred to a new owner.

##### Function used for make offer

```
function makeOffer(uint _id, uint _price) public {
    nftCAmit.transferFrom(msg.sender, address(this), _id);                //  it's defination wtitten in ERC721 and used to list offer in market place where msg.sender = creator address, address(this) = Market address, _id = NFT id
    offerCount ++;
    offers[offerCount] = _Offer(offerCount, _id, msg.sender, _price, false);  // it's set price of NFT in ETH and set fulfilled variable as false means it's not sold.
    emit Offer(offerCount, _id, msg.sender, _price, false);
  }
```

#### View Offer
The user must input offerid to see the order .
Offer structure on the market place is like this:
```
 struct _Offer {
    uint offerId;
    uint id;
    address user;
    uint price;
    bool fulfilled;
    
  }
```

##### Mapping used for view offer
```
mapping (uint => _Offer) public offers;  // you can see offer detail by passing offerid
```
<img src="https://pbx.toggle.com.co/amitgithub/viewoffer.jpeg" width="250">




#### Buy
A user can buy those NFT which someone else offered. This will require paying the requested price (the Ether will be transferred to the smart contract to be claimed later on).

##### Function used for fillOffer
```
  function fillOffer(uint _offerId) public payable {
      
    _Offer storage _offer = offers[_offerId];
    require(_offer.offerId == _offerId, 'The offer must exist');
    require(_offer.user != msg.sender, 'The owner of the offer cannot fill it');
    require(!_offer.fulfilled, 'An offer cannot be fulfilled twice');
    require(msg.value == _offer.price, 'The ETH amount should match with the NFT Price');
    nftCAmit.transferFrom(address(this), msg.sender, _offer.id);                   //  it's defination wtitten in ERC721 and used to change owner where msg.sender = buyer address, address(this) = Market address, _offer.id = NFT id
    _offer.fulfilled = true;                                                       // it's set price of NFT in ETH and set fulfilled variable as true means its  sold.
    userFunds[_offer.user] += msg.value;                                           
    emit OfferFilled(_offerId, _offer.id, msg.sender);
  }
```
<img src="https://pbx.toggle.com.co/amitgithub/sold.jpeg" width="250">

#### Claim Funds
If a user sold an NFT, he can claim his funds by using claimFunds .


## How to Compile and Deploy these smart Contract
1. Open remix IDE(https://remix.ethereum.org/).
2. Create newnft.sol and newmarket.sol files and copy their codes.
3. Compile both solidty files.
4. Deploy NFTAmit-newnft.sol Then Deploy Market-newmarket.sol with NFTAmit contract address.

## Test
1. Mint a NFT by entering _tokenURI safeMint in NFTAmit.
2. Create offer by using makeOffer in Market ,here you can set NFT id and price. ("ERC721: transfer caller is not owner nor approved".it can be resolve by setting Market contract address as operator and flag true in setApprovalForAll in NFTAmit )
3. When transaction complete then you can see the owner of NFT (in NFTAmit ) change to Market contract address and offercount increase, you can view that offer in offers.  
4. Now, change  eth address in remix IDE and purchage that NFT by using fillOffer in Market.("The ETH amount should match with the NFT Price".  it can be resolve by set equal amount of NFT Price in value field of remix IDE before transaction) 

5. After successful transaction you can see owner of NFT is changed by purchaser address, And you can also see seller get funds in userFunds.
6. you can withdraw that funds by using claimFunds in Market.
 
 


