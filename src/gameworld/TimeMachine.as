package gameworld 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author ...
	 */
	public class TimeMachine 
	{
		private var timeSkip:int = 1;
		private var rewindCount:int = 0;
		
		public var worldMemos:Array=[];
		public var world:Game;
		
		public var recording:Boolean = true;
		public var rewinding:Boolean = false;
		
		public var currentIndex:int = 0;
		
		public function TimeMachine(world:Game) 
		{
			this.world = world;
		}
		
		
		public function RecordRewind():void
		{
			if (rewinding)
			{
				StopRewinding();
			} else
			{
				StartRewinding();
			}
			
		}
		
		public function Update():void
		{
			if (recording)
			{
				worldMemos.push(world.GetMemento());
				currentIndex++;
			}
			
			var worldMemo:WorldMemento;
			
			if (rewinding)
			{
				if (Input.check(Key.LEFT) || Input.check(Key.A) || Input.check(Key.RIGHT) || Input.check(Key.D) || Input.check(Key.UP) || Input.check(Key.W))
				{
					return StopRewinding();
				}
				
				if (worldMemos.length > 0)
				{
					for (var i:int = 0; i < timeSkip; i++) 
					{
						worldMemo = worldMemos.pop();
						currentIndex--;
						if (!worldMemo || worldMemos.length==0)
							break;
					}
					
					if (worldMemo)
					world.SetMemento(worldMemo);
					
					rewindCount++;
					
					if (rewindCount == 300)
					{
						//world.text.text = "timeskip x2";
						timeSkip = 2;
					}
					if (rewindCount == 300*2)
					{
						//world.text.text = "timeskip x3";
						timeSkip = 3;
					}
					if (rewindCount == 300*3)
					{
						//world.text.text = "timeskip x4";
						timeSkip = 4;
					}
					if (rewindCount == 300*4)
					{
						//world.text.text = "timeskip x5";
						timeSkip = 5;
					}
				}
				else
				{
					StopRewinding();
					
				}
			}			
		}
		
		private function StopRewinding():void 
		{
			world.text.text = "";
			rewinding = false;
			recording = true;
			world.paused = false;
			
		}
		
		private function StartRewinding():void 
		{
			rewinding = true;
			world.paused = true;
			recording = false;
			rewindCount = 0;
			timeSkip = 1;
			world.text.text = "time goes back..";
		}
		
		

		
		
		
	}

}