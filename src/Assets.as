package  
{
	
	public class Assets
	{
		
		// levelsss!
		//[Embed(source = "../assets/lvl/level01.oel", mimeType = "application/octet-stream")] public static const LEVEL01:Class;
		
		//public static const LEVELS:Array = [LEVEL01, LEVEL02, LEVEL03, LEVEL04, LEVEL05, LEVEL06, LEVEL07, LEVEL08];
		
		// graphics!
		//[Embed(source = "../assets/graphics/tileset.png")] public static const TILESET:Class;
		[Embed(source = "../assets/img/gazenwagen_anime.png")] public static const GAZENWAGEN:Class;
		[Embed(source = "../assets/img/soldier.png")] public static const SOLDIER:Class;
		[Embed(source = "../assets/img/soldier_w_weapon.png")] public static const SOLDIER_W_WEAPON:Class;
		[Embed(source = "../assets/img/soldier_w_weapon_firing.png")] public static const SOLDIER_W_WEAPON_FIRING:Class;
		[Embed(source = "../assets/img/prisoner.png")] public static const PRISONER:Class;
		[Embed(source = "../assets/img/prisoner_anime.png")] public static const PRISONER_ANIME:Class;
		[Embed(source = "../assets/img/spikes_anime.png")] public static const SPIKES_ANIME:Class;
		
		[Embed(source = "../assets/img/beton_tile.png")] public static const BETON:Class;
		[Embed(source="../assets/img/bricks_tile.png")] public static const BRICKS1:Class;
		[Embed(source = "../assets/img/bricks_tile2.png")] public static const BRICKS2:Class;
		[Embed(source = "../assets/img/banner.png")] public static const BANNER:Class;
		
		[Embed(source = "../assets/img/door.png")] public static const DOOR:Class;
		[Embed(source="../assets/img/opendoor.png")] public static const OPENDOOR:Class;
		
		
		// soundszz
		//[Embed(source = "../assets/snd/die.mp3")] public static const SN_DIE:Class;
		
		
		// levels
		[Embed(source = "../assets/lvl/scene1.oel", mimeType = "application/octet-stream")] public static const SCENE1:Class;
		[Embed(source = "../assets/lvl/level01.oel", mimeType = "application/octet-stream")] public static const LEVEL01:Class;
		[Embed(source = "../assets/lvl/level02.oel", mimeType = "application/octet-stream")] public static const LEVEL02:Class;
		[Embed(source = "../assets/lvl/level03.oel", mimeType = "application/octet-stream")] public static const LEVEL03:Class;
		
		public static const LEVELS:Array = [SCENE1,LEVEL01, LEVEL02,LEVEL03];
		
	}

}