package gameworld 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author 
	 */
	public class Game extends World
	{
		public var enemies:Vector.<Enemy>=new Vector.<Enemy>();
		public var hero:Hero;
		public var gazenWagen:GazenWagen;
		public var text:Text;
		public var paused:Boolean = false;
		public var timeMachine:TimeMachine;
		public var level:int;
		public var playerCamera:Camera;
		
		public var winLevel:Boolean = false;
		public var heroDiedWithoutImmortality:Boolean = false;
		public var heroDiedWithoutImmortalityCounter:int= 0;
		
		public var scene1Mode:Boolean = false;
		
		
		public function Game(level:int) 
		{
			this.level = level;
		}
		
		override public function begin():void 
		{
			//time
			playerCamera = add(new Camera()) as Camera;
			
			
			timeMachine = new TimeMachine(this);
			
			LoadLevel(level);
			
			text = new Text("schnell! schnell zu erholen die gazenvagen!", 100, 10, { size:8 } );
			if (level != 1)
			text.text = "";
			text.scrollX = text.scrollY = 0;
			addGraphic(text);
			
			playerCamera.SetTo(hero.x, hero.y);
			playerCamera.FollowTarget(hero);
		}
		
		private function LoadLevel(level:int):void 
		{
			if (level == 1 ) scene1Mode = true;
			
			var xml:XML, o:XML, n:XML;
			xml = FP.getXML(Assets.LEVELS[level - 1]);
			
			FP.screen.color = 0x141414;
			
			
			// place tiles
			for each(o in xml.walls[0].tile)
			{
				add(new Wall(o.@x, o.@y, 16, 16));
			}
			
			//banners
			for each(o in xml.objects[0].banner)
			{
				add(new Banner(int(o.@x), int(o.@y)));
			}
			
			
			
			//gazenwagen
			for each(o in xml.objects[0].gazenwagen)
			{
				gazenWagen = add(new GazenWagen(int(o.@x), int(o.@y))) as GazenWagen;
			}
			
			//doors
			for each(o in xml.objects[0].end)
			{
				add(new Door(int(o.@x), int(o.@y)));
			}
			
			//open doors
			for each(o in xml.objects[0].opendoor)
			{
				add(new Door(int(o.@x), int(o.@y),true));
			}
			
			// add soldiers
			for each(o in xml.objects[0].soldier)
			{
				enemies.push(add(new Enemy(int(o.@x), int(o.@y))) as Enemy);
			}			
			
			// add player
			for each(o in xml.objects[0].start)
			{
				hero = add(new Hero(int(o.@x), int(o.@y))) as Hero;
				
			}			
			// add player
			for each(o in xml.objects[0].spikes)
			{
				add(new Spikes(int(o.@x), int(o.@y)));
				
			}			
			
			
			//add(new Spikes(124 - 16 * 3, 100 - 16));
			
			
			
			//enemies.push(add(new Enemy(116, 50 -18)) as Enemy);
			
			
		}
		
		override public function end():void 
		{
			
		}
		
		override public function update():void 
		{
			//if (Input.pressed(Key.SPACE)) paused = !paused;
			/*if (Input.pressed(Key.SPACE)) 
			{
				timeMachine.RecordRewind();
				
			}*/
			
			super.update();
			
			if (winLevel)
			{
				if (level >= Assets.LEVELS.length)
				{
					paused = true;
					FP.world = new GameOver(true);
				} else
				{
					paused = true;
					FP.world = new Game(level + 1);
				}
			} else
			if (heroDiedWithoutImmortality)
			{
				heroDiedWithoutImmortalityCounter++;
				if (heroDiedWithoutImmortalityCounter > 30)
				{
					FP.world = new GameOver();
				}
			} else
			{
				timeMachine.Update();
			}
			
			
			
		}
		
		public function GetMemento():WorldMemento
		{
			var memo:WorldMemento = new WorldMemento();
			memo.heroMemento = hero.GetMemento();
			
			memo.enemyMementos = new Vector.<EnemyMemento>();
			for (var i:int = 0; i < enemies.length; i++) 
			{
				memo.enemyMementos.push(enemies[i].GetMemento());
			}
			
			if (gazenWagen)
			{
				memo.gazenWagen = gazenWagen.GetMemento();
			}
			return memo;
		}
		
		public function SetMemento(memo:WorldMemento):void
		{
			hero.SetMemento(memo.heroMemento);
			
			for (var i:int = 0; i < memo.enemyMementos.length; i++) 
			{
				this.enemies[i].SetMemento(memo.enemyMementos[i]);
			}			
			if (gazenWagen)
			{
				gazenWagen.SetMemento(memo.gazenWagen);
			}
		}
		
	}

}