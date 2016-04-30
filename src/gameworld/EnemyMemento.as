package gameworld 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyMemento 
	{
		public var jumpPressed:Boolean;
		public var jumpCounter:int;
		
		public var speed:Point;
		public var maxspeed:Point;
		
		public var direction:int;
		public var onGround:Boolean;
		
		public var inputLeft:Boolean;
		public var inputRight:Boolean;
		public var inputUp:Boolean;
		
		public var horizontalSpeed:Number;
		public var verticalSpeed:Number;
		
		public var hp:int;
		public var alive:Boolean;
		
		//fp stuff
		public var x:Number;
		public var y:Number;
		
		public var sprite_flipped:Boolean;
		public var sprite_anim:String;
		public var sprite_frame:int;
		
		//ai
		public var aiMode:int;
		public var aiMemory:Object;
		
		
		public var jumping:Boolean = false;
		public var firing:Boolean = false;
		public var walking:Boolean = false;
		public var staggering:Boolean = false;
		public var dying:Boolean = false;
		
		
		//scene
		public var scene1Mode:Boolean;
		
		
	}

}