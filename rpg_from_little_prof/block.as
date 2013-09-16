#initclip

function Block() 
{
	// The only difference between a movie clip and a block
	// is that a block is a block!
	// We will use instanceof to check for blocks.
}

Block.prototype = new MovieClip();

Object.registerClass("Block", Block);

#endinitclip
