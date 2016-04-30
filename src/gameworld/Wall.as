package gameworld 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	public class Wall extends Entity
	{
		
		public function Wall(x:int, y:int, w:int, h:int) 
		{
			super(x, y);
			setHitbox(w, h);
			type = "solid";
			//graphic = new Image(Assets.BETON);
			//graphic = new Image(Assets.BETON);
			graphic = new Image(Assets.BRICKS2);
			//visible = false;
		}
		
	}

}