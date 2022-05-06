pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";


contract MyEpicNFT is ERC721URIStorage {
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;


    uint mintedNFT = 25;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg(we are concatenating this with some text from our random generator and the end of the svg code to make the finalSVG) variable here that all our NFTs can use.
    //string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: #070D18; font-family: serif; font-size: 24px; } .number { fill: #070D18; font-size: 12px;} </style><rect width='100%' height='100%' fill='#F4C262'/><path fill-rule='evenodd' clip-rule='evenodd' d='M23 23.3333C23 22.597 23.597 22 24.3333 22H40.3333C41.0697 22 41.6667 22.597 41.6667 23.3333V23.3333C41.6667 24.0697 41.0697 24.6667 40.3333 24.6667V24.6667C39.597 24.6667 39 25.2636 39 26V34.6667C39 35.0349 39.2985 35.3333 39.6667 35.3333V35.3333C40.0349 35.3333 40.3333 35.6318 40.3333 36V36.6667C40.3333 37.403 39.7364 38 39 38H38.3333C37.2288 38 36.3333 37.1046 36.3333 36V34C36.3333 33.2636 35.7364 32.6667 35 32.6667V32.6667C34.2636 32.6667 33.6667 33.2636 33.6667 34V34.6667C33.6667 35.0349 33.9651 35.3333 34.3333 35.3333V35.3333C34.7015 35.3333 35 35.6318 35 36V36.6667C35 37.403 34.403 38 33.6667 38H31C30.2636 38 29.6667 37.403 29.6667 36.6667V36C29.6667 35.6318 29.9651 35.3333 30.3333 35.3333V35.3333C30.7015 35.3333 31 35.0349 31 34.6667V34C31 33.2636 30.403 32.6667 29.6667 32.6667V32.6667C28.9303 32.6667 28.3333 33.2636 28.3333 34V36C28.3333 37.1046 27.4379 38 26.3333 38H25.6667C24.9303 38 24.3333 37.403 24.3333 36.6667V36C24.3333 35.6318 24.6318 35.3333 25 35.3333V35.3333C25.3682 35.3333 25.6667 35.0349 25.6667 34.6667V26C25.6667 25.2636 25.0697 24.6667 24.3333 24.6667V24.6667C23.597 24.6667 23 24.0697 23 23.3333V23.3333ZM35 30C35.7364 30 36.3333 29.403 36.3333 28.6667V26C36.3333 25.2636 35.7364 24.6667 35 24.6667V24.6667C34.2636 24.6667 33.6667 25.2636 33.6667 26V28.6667C33.6667 29.403 34.2636 30 35 30V30ZM31 28.6667C31 29.403 30.403 30 29.6667 30V30C28.9303 30 28.3333 29.403 28.3333 28.6667V26C28.3333 25.2636 28.9303 24.6667 29.6667 24.6667V24.6667C30.403 24.6667 31 25.2636 31 26V28.6667Z' fill='#1F2632'/><path d='M28.3333 40.6667C28.3333 39.9303 28.9303 39.3333 29.6667 39.3333H35.3333C36.0697 39.3333 36.6667 39.9303 36.6667 40.6667V40.6667C36.6667 41.403 36.0697 42 35.3333 42H29.6667C28.9303 42 28.3333 41.403 28.3333 40.6667V40.6667Z' fill='#1F2632'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string firstPartSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: #070D18; font-family: serif; font-size: 24px; } .number { fill: #070D18; font-size: 12px; font-weight: bold;}</style><rect width='100%' height='100%' fill='";
    string secondPartSvg = "'/><rect x='290' y='22' width='40' height='20' rx='10' fill='#FEFEFE'/><path fill-rule='evenodd' clip-rule='evenodd' d='M23 23.3333C23 22.597 23.597 22 24.3333 22H40.3333C41.0697 22 41.6667 22.597 41.6667 23.3333V23.3333C41.6667 24.0697 41.0697 24.6667 40.3333 24.6667V24.6667C39.597 24.6667 39 25.2636 39 26V34.6667C39 35.0349 39.2985 35.3333 39.6667 35.3333V35.3333C40.0349 35.3333 40.3333 35.6318 40.3333 36V36.6667C40.3333 37.403 39.7364 38 39 38H38.3333C37.2288 38 36.3333 37.1046 36.3333 36V34C36.3333 33.2636 35.7364 32.6667 35 32.6667V32.6667C34.2636 32.6667 33.6667 33.2636 33.6667 34V34.6667C33.6667 35.0349 33.9651 35.3333 34.3333 35.3333V35.3333C34.7015 35.3333 35 35.6318 35 36V36.6667C35 37.403 34.403 38 33.6667 38H31C30.2636 38 29.6667 37.403 29.6667 36.6667V36C29.6667 35.6318 29.9651 35.3333 30.3333 35.3333V35.3333C30.7015 35.3333 31 35.0349 31 34.6667V34C31 33.2636 30.403 32.6667 29.6667 32.6667V32.6667C28.9303 32.6667 28.3333 33.2636 28.3333 34V36C28.3333 37.1046 27.4379 38 26.3333 38H25.6667C24.9303 38 24.3333 37.403 24.3333 36.6667V36C24.3333 35.6318 24.6318 35.3333 25 35.3333V35.3333C25.3682 35.3333 25.6667 35.0349 25.6667 34.6667V26C25.6667 25.2636 25.0697 24.6667 24.3333 24.6667V24.6667C23.597 24.6667 23 24.0697 23 23.3333V23.3333ZM35 30C35.7364 30 36.3333 29.403 36.3333 28.6667V26C36.3333 25.2636 35.7364 24.6667 35 24.6667V24.6667C34.2636 24.6667 33.6667 25.2636 33.6667 26V28.6667C33.6667 29.403 34.2636 30 35 30V30ZM31 28.6667C31 29.403 30.403 30 29.6667 30V30C28.9303 30 28.3333 29.403 28.3333 28.6667V26C28.3333 25.2636 28.9303 24.6667 29.6667 24.6667V24.6667C30.403 24.6667 31 25.2636 31 26V28.6667Z' fill='#1F2632'/><path d='M28.3333 40.6667C28.3333 39.9303 28.9303 39.3333 29.6667 39.3333H35.3333C36.0697 39.3333 36.6667 39.9303 36.6667 40.6667V40.6667C36.6667 41.403 36.0697 42 35.3333 42H29.6667C28.9303 42 28.3333 41.403 28.3333 40.6667V40.6667Z' fill='#1F2632'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string thirdPartSvg = "</text><text x='306' y='33' class='number' dominant-baseline='middle' text-anchor='middle'>#";

     // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever! 
    string[] firstWords = ["Infallible", "Flimsy", "Infamous", "Immortal", "Inevitable", "Insolent", "Maleficent", "Malevolent", "Impolite", "Disrespectful", "Impudent", "Nasty", "Glitchy", "Unimaginable", "Unquestionable", "Unhinged", "Unstoppable", "Explosive", "Impatient", "Sketchy"];
    string[] secondWords = ["Gojo", "Aomine","Midorima", "Killua", "Yami", "Kaneki", "Sukuna", "Asta", "Kurama", "Megicula", "Gimodelo", "Saitama", "Zagred", "Slotos", "Dexter", "Jaraiya"];
    string[] thirdWords = ["Sauce", "Juice", "Swag", "Stealth", "Finesse", "Grip", "Stamina", "Strength", "Composure", "Audacity", "Aura", "Resolve", "Nonchalance", "Zest", "Gusto", "Power"];
    string[] colors = ["#F4C262", "#D9E4F6", "#E6DDCB", "FEFEFE", "#FFE7B7", "#FFC1BD", "#A9A8F6", "#FFB1A3", "#E0FDFF", "#E9FFE5", "#FFD9D9", "#E5D9FF"];
    

    event NewEpicNFTMinted(address sender, uint256 tokenId, string nftName);

    // We need to pass the name of our NFTs token and it's symbol.
    constructor() ERC721 ("SquareNFT","SQUARE") {
        console.log("Testing the NFT contract");
    }

    //a function that returns the a hash of a word to create a tokenId
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // I seed the random generator. More on this in the lesson. 
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint tokenId) public view returns(string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
        
    }


    function getTotalNFTsMinted() public view returns(uint) {
        return mintedNFT;
    }

    // A function our user will call to get their NFT.
    function makeAnEpicNFT() public {
        require(mintedNFT < 50, "No more NFTs to mint");
        //Get the current tokenID, this starts at 0
        uint256 newItemId = _tokenIds.current();

        // We go and randomly grab one word from each of the three arrays.
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));
        string memory color = pickRandomColor(newItemId);
        string memory number  = Strings.toString(newItemId);



        // I concatenate it all together, and then close the <text> and <svg> tags.
        //string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
        string memory finalSvg = string(abi.encodePacked(firstPartSvg, color, secondPartSvg, combinedWord, thirdPartSvg, number, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    // We set the title of our NFT as the generated word.
                    abi.encodePacked(
                      '{"name": "',combinedWord,'", "description": "A highly acclaimed collection of squares by 7of.", "image": "data:image/svg+xml;base64,',Base64.encode(bytes(finalSvg)),'"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );


        console.log("\n--------------------");
        //console.log(finalTokenUri);
        console.log( 
            string(
                abi.encodePacked("https://nftpreview.0xdev.codes/?code=",finalTokenUri)
                )
            );
        console.log("--------------------\n");

        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFTs data.
        _setTokenURI(newItemId, finalTokenUri);
        // _setTokenURI(newItemId, "data:application/json;base64,eyJuYW1lIjoiSW5mYWxsaWJsZUdvam9TYXVjZSIsImRlc2NyaXB0aW9uIjoiQW4gTkZUIGZyb20gdGhlIGhpZ2hseSBhY2NsYWltZWQgc3F1YXJlIGNvbGxlY3Rpb24iLCJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjRiV3h1Y3owaWFIUjBjRG92TDNkM2R5NTNNeTV2Y21jdk1qQXdNQzl6ZG1jaUlIQnlaWE5sY25abFFYTndaV04wVW1GMGFXODlJbmhOYVc1WlRXbHVJRzFsWlhRaUlIWnBaWGRDYjNnOUlqQWdNQ0F6TlRBZ016VXdJajRLSUNBZ0lEeHpkSGxzWlQ0dVltRnpaU0I3SUdacGJHdzZJSGRvYVhSbE95Qm1iMjUwTFdaaGJXbHNlVG9nYzJWeWFXWTdJR1p2Ym5RdGMybDZaVG9nTVRSd2VEc2dmVHd2YzNSNWJHVStDaUFnSUNBOGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaUJtYVd4c1BTSmliR0ZqYXlJZ0x6NEtJQ0FnSUR4MFpYaDBJSGc5SWpVd0pTSWdlVDBpTlRBbElpQmpiR0Z6Y3owaVltRnpaU0lnWkc5dGFXNWhiblF0WW1GelpXeHBibVU5SW0xcFpHUnNaU0lnZEdWNGRDMWhibU5vYjNJOUltMXBaR1JzWlNJK1NXNW1ZV3hzYVdKc1pVZHZhbTlUWVhWalpUd3ZkR1Y0ZEQ0S1BDOXpkbWMrIn0=");
        
        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
        //log which NFT is minted by whom
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        emit NewEpicNFTMinted(msg.sender, newItemId, combinedWord);
        mintedNFT++;
        console.log(mintedNFT);
    }

}
