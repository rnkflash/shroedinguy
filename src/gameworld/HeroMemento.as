package gameworld 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class HeroMemento 
	{
		public var jumpPressed:Boolean;
		public var jumpCounter:int;
		
		public var speed:Point;
		
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
		
		public var visible:Boolean;
		
		
	}

}