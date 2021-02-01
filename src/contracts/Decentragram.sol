pragma solidity ^0.5.0;

contract Decentragram {
  
 	string public name = "Decentragram";

 	//Store Images
 	uint public imageCount = 0;
 	mapping(uint => Image) public images;

 	struct Image {
 		uint id;
 		string hash;
 		string description;
 		uint tipAmount;
 		address payable author;
 	}

 	event ImageCreated (
 		uint id,
 		string hash,
 		string description,
 		uint tipAmount,
 		address payable author
 	);

 	event ImageTipped (
 		uint id,
 		string hash,
 		string description,
 		uint tipAmount,
 		address payable author
 	);

 	//Create Images
 	function uploadImage(string memory _imgHash, string memory _description) public{
 		
 		require(bytes(_imgHash).length > 0);
 		require(bytes(_description).length > 0);
 		require(msg.sender != address(0x0));

 		// Increment image id
 		imageCount++;

 		//Add imagge to contract
 		images[1] = Image(imageCount, _imgHash, _description, 0, msg.sender);
 	
 		// Triger an event
 		emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
 	}


 	// Tip Images
 	function tipImageOwner(uint _id) public payable {
 		// Make sure the tip is valid
 		require(_id > 0 && _id <= imageCount);
 		
 		//Fetch the image and fetch the author
 		Image memory _image = images[_id];
 		address payable _author = _image.author;

 		// Pay the author sending them the tip in Ether
 		address(_author).transfer(msg.value);
 		
 		// Increment tip amount
 		_image.tipAmount += msg.value;
 		
 		//Update image
 		images[_id] = _image; 

 		//Triger an event
 		emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
 	}

}