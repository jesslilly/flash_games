Terrain = function()
{
   //no instance variables.
};
Terrain.PLAINS = 1; // 00FF00
Terrain.DESERT = 2; // FFDD99
Terrain.GRASSLAND = 3; // FFDD00
Terrain.HILL = 4; // 996633
Terrain.MOUNTAIN = 5; // CCCCCC
Terrain.OCEAN = 6; // 00BBFF
Terrain.PINES = 7; // 005533

Terrain.terrainNumberToString = function( terrainNumber )
{
	var terrainString = "plains";
	switch ( terrainNumber )
	{
		case 2:
			terrainString = "desert";
			break;
		case 3:
			terrainString = "grassland";
			break;
		case 4:
			terrainString = "hill";
			break;
		case 5:
			terrainString = "mountain";
			break;
		case 6:
			terrainString = "ocean";
			break;
		case 7:
			terrainString = "pines";
			break;
	}
	trace( " number " + terrainNumber + " is " + terrainString );
	return terrainString;
};
