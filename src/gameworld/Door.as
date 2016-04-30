package gameworld 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	public class Door extends Entity
	{
		private var open:Boolean;
		
		public var sprite:Spritemap;
		
		public var papa:Game;
		
		public function Door(x:int, y:int,open:Boolean=false) 
		{
			if (open)
			sprite = new Spritemap(Assets.OPENDOOR, 13, 20);
			else
			sprite = new Spritemap(Assets.DOOR, 13, 20);
			super(x, y,sprite);
			
			this.open = open;
			
			
			sprite.add("closed", [0], 0, false);
			//sprite.add("open", [1], 0, false);
			
			
			sprite.play("closed");
			
			setHitbox(3, 3,-5,-17);
			type = "door";
			
			
		}
		
		override public function added():void 
		{
			super.added();
			
			papa = world as Game;
		}
		
		override public function update():void 
		{
			if (papa.paused || open) return;
			
			if (collideWith(papa.hero,x,y))
			{
				//trace("we eat him");
				papa.winLevel = true;
			}
		}
		
	}

}