package gameworld 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	public class GazenWagen extends Entity
	{
		
		
		public var sprite:Spritemap = new Spritemap(Assets.GAZENWAGEN, 50, 35);
		
		public var papa:Game;
		
		public var scene0HeroAproaches:Boolean = true;
		
		public var scene1HeroEaten:Boolean = false;
		public var scene1Counter1:int = 0;
		
		private var scene2Gas:Boolean=false;
		private var scene2WaitBlink:Boolean = false;
		
		public function GazenWagen(x:int, y:int) 
		{
			super(x, y,sprite);
			
			sprite.add("closed", [0], 0, false);
			sprite.add("open", [1], 0, false);
			sprite.add("gas", [2,3,3,4,4,4,0,0,0,0,0,0], 12, true);
			sprite.play("open");
			setHitbox(3, 3,-15,-31);
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
			
			if (scene0HeroAproaches)
			{
				if (collideWith(papa.hero,x,y))
				{
					//trace("we eat him");
					sprite.play("closed");
					papa.hero.visible = false;
					papa.hero.controllable = false;
					scene1HeroEaten = true;
					scene0HeroAproaches = false;
					
					
				}
			} else
			if (scene1HeroEaten)
			{
				scene1Counter1++;
				if (scene1Counter1 > 30)
				{
					scene1HeroEaten = false;
					scene2Gas = true;
					scene1Counter1 = 0;
					sprite.play("gas");
				}
			}
			else
			if (scene2Gas)
			{
				scene1Counter1++;
				if (scene1Counter1 > 40)
				{
					sprite.play("closed");
					Main.blink = true;
					scene2Gas = false;
					
					scene2WaitBlink = true;
					scene1Counter1 = 0;
				}
			} 
			else
			if (scene2WaitBlink)
			{
				scene1Counter1++;
				if (scene1Counter1 > 30)
				{
					//papa.hero.visible = true;
					papa.hero.controllable = true;
					papa.hero.Hit(1.0, true);
					scene2WaitBlink = false;
					
					papa.hero.alive = false;
					Hero.immortal = true;
					
				}
			}
			
			
			
		}
		
		public function GetMemento():GazenWagenMemento
		{
			var memo:GazenWagenMemento = new GazenWagenMemento();
			memo.sprite_anim = this.sprite.currentAnim;
			memo.sprite_frame = this.sprite.frame;
			return memo;
		}
		
		public function SetMemento(memo:GazenWagenMemento):void
		{
			this.sprite.play(memo.sprite_anim, true, memo.sprite_frame);
			
			scene0HeroAproaches = true;
		}
	}

}