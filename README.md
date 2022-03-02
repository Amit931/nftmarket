# Simple NFT
Solidity Contracts of simple NFT Mint and Marketplace

## Discription
I have write a code for mint a simple NFT by using openzeppelin lib in newnft.sol file and create a simple market place in newmarket.sol file.

### Function and code Discription of newnft.sol

Here I import ERC721.sol from openzeppelin lib. and create a contract NFTAmit which is inherited by ERC721.In this contarct i have used 3 variable these are:

tokenURIs  Type String array to contain URI of NFT.  <br />
 _tokenURIExists it's a mapping variable string(URI) => bool ,to check is URI exist or not (uri is a unique for every NFT). <br />
 _tokenIdToTokenURI it's a mapping variable uint(NFT id) => string(URI). <br />
 
 there are i use two functions 
 1. tokenURI - I use it to find NFT URI on the behalf of id.<br />
 2. safeMint - In safeMint function i pass uri string which is going to mint. In first line of function i have checked uniqueness of token. In second line of function i have pUsh Uri string into the tokenURIs array.In thired line of function i have get length of tokenURIs array and assign it into the fiunction variable _id. In fourth line of function i have mapped _id to uri (its for uniqueness). Now we have to go mint so i use _safeMint function its defination is written in ERC721 . And in the last  i update _tokenURIExists = true <br />
 
 
 
 ### Function and code Discription of newmarket.sol
 
 Here i import newnft.sol after that i create a Contract and use 4 global variable and a structure of offer.these are <br />
 1. offerCount type int and increament in offrer generation.
 2. offers its a mapping variable id(offerid) => _offer(structure);
 3. userFunds its a mapping variable address(ETH address) => uint(fund)
 4. nftCAmit its a instance of  NFTAmit contract.
  
  struct _Offer { <br />
    uint offerId;   -- its use for unique offerid  <br />
    uint id ;       -- NFT id which is created by NFTAmit contract <br />
    address user;   -- offer creator address <br />
    uint price;     -- NFT price <br />
    bool fulfilled; -- its a flag shows NFT Sold or Not <br />
    
  } <br /><br />
 
 In constructor i have pass address of NFTAmit contract and create an object that is nftCAmit.<br />
 
 i have used four basic functions in it.<br />
 1. makeOffer(_id, _price) - we create offer by using this function, here i use nftCAmit.transferFrom(msg.sender, address(this), _id) function . 
    Here msg.sender is a glbal veriable and in this function it's contain offer creator address, address(this contain contract address of Market) and _id contains  NFT id which is created by NFTAmit contract.
    increament offerCount variable (array index start with 0 so we avoid this).
    and now we create offer by filling _offer structure attribute(offerId = offerCount, id = _id, user= msg.sender, price= _price, fulfilled= false) and map with offerCount. 

2. fillOffer(_offerId) - This function used to buy NFT from Market and update status of fulfilled = true .in this funtion first we retrive offer on the behalf of _offerId which is passed as input of function .Then i check certain checks like offer exists or not, owner con't buy its on NFT, NFT alredy sold, eth value is equal to NFT Price. after that i change   NFT owner by using nftCAmit.transferFrom(address(this), msg.sender, _offer.id) function . here address(this) is contain address of Market contract, msg.sender is contain buyer address and _offer.id contains NFT id which is created by NFTAmit contract.at in last i update fulfilled flag true and update seller fund in market contract.

3. claimFunds() - This function used to claim fund which is received by selling NFT.

4. fallback () - This function used to reverts if Ether is sent to this smart-contract by mistake.


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
 
 


