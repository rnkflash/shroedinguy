package gameworld 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Sulus Ltd.
	 */
	public class Camera extends Entity 
	{
		private static const IDLE:int = 0;
		private static const FOLLOWING:int = 1;
		private static const MOVING:int = 2;
		
		public static const EVENT_MOVE_COMPLETE:String = "move_complete";
		public var eventDispatcher:EventDispatcher;
		
		private var destination:Point;
		private var target:Entity;
		private var mode:int = IDLE;
		private var bounds:Rectangle;
		
		
		public function Camera() 
		{
			width = Main.WIDTH;
			height = Main.HEIGHT;
			
			eventDispatcher = new EventDispatcher();
			
		}
		
		public function SetBounds(bounds:Rectangle):void
		{
			this.bounds = bounds;
		}
		
		public function FollowTarget(target:Entity):void
		{
			this.target = target;
			this.mode = FOLLOWING;
		}
		
		public function MoveTo(destination:Point):void
		{
			this.destination = destination;
			this.mode = MOVING;
		}
		
		public function SetTo(x:Number,y:Number):void
		{
			
			var halfWidth:int = width / 2;
			var halfHeight:int = height / 2;
			this.x = x;
			this.y = y;
			if (bounds)
			{
				x = Math.max(bounds.x + halfWidth, Math.min(x, bounds.x + bounds.width - halfWidth));
				y = Math.max(bounds.y + halfHeight, Math.min(y, bounds.y + bounds.height - halfHeight));
			} 
			
			FP.camera.x = x - halfWidth;
			FP.camera.y = y - halfHeight;
		}
		
		
		override public function update():void 
		{
			switch (mode) 
			{
				case FOLLOWING:
				{
					var dx:Number = (target.x - x) * 0.5;
					var dy:Number = (target.y - y) * 0.5;
					
					if (Math.abs(dx) < 1.0 && Math.abs(dy) < 1.0)
					{
						SetTo(target.x, target.y);
					} else
					{
						SetTo(x + dx, y + dy);
					}
					
				}	
				break;
				case MOVING:
				{
					dx = (destination.x  - x) * 0.5;
					dy = (destination.y  - y) * 0.5;
					
					if (Math.abs(dx) < 1.0 && Math.abs(dy) < 1.0)
					{
						this.mode = IDLE;
						SetTo(destination.x, destination.y);
						eventDispatcher.dispatchEvent(new Event(EVENT_MOVE_COMPLETE));
					} else
					{
						SetTo(x + dx, y + dy);
					}
				}	
				break;
			}
		}
		
		
		
	}

}