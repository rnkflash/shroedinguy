package gameworld 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	public class Banner extends Entity
	{
		
		public function Banner(x:int, y:int) 
		{
			super(x, y);
			type = "background";
			graphic = new Image(Assets.BANNER);
		}
		
	}

}