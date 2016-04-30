package gameworld 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	public class Spikes extends Entity
	{
		
		public var sprite:Spritemap = new Spritemap(Assets.SPIKES_ANIME, 16, 16);
		
		
		
		public var papa:Game;
		
		public function Spikes(x:int, y:int) 
		{
			super(x, y,sprite);
			
			sprite.add("attack_nonstop", [0, 1, 2,2,2, 1,0], 16, true);
			sprite.add("attack", [0, 1, 2], 10, false);
			sprite.play("attack_nonstop");
			setHitbox(16, 6,0,-10);
			type = "enemy";
			
			
		}
		
		override public function added():void 
		{
			super.added();
			
			papa = world as Game;
		}
		
		override public function update():void 
		{
			if (papa.paused) return;
			
			if (collideWith(papa.hero,x,y))
			{
				papa.hero.Hit(1);
			}
		}
		
	}

}