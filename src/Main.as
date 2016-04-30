package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import gameworld.Game;
	import gameworld.GameOver;
	import gameworld.Menu;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	public class Main extends Engine
	{
		
		public static const WIDTH:int = 300;
		public static const HEIGHT:int = 200;
		
		public static var overlay:Bitmap = new Bitmap(new BitmapData(WIDTH, HEIGHT, true, 0x00000000));
		public static var blink:Boolean = false;
		public static var blinkProgress:Number = -1.0;
		
		public static var fade:Boolean = false;
		public static var fadeDestColor:uint = 0xff000000;
		public static var fadeCallback:Function;
		public static var fadeProgress:Number = 0.0;
		
		public function Main():void 
		{
			
			super(WIDTH, HEIGHT, 30, false);
			FP.screen.scale = 2.0;
			FP.screen.color = 0x000000;
			overlay.scaleX = overlay.scaleY = 2.0;
			FP.engine.addChild(overlay);
			//FP.world = new Game(1);
			FP.world = new Menu();
			//FP.world = new Game(2);
			//FP.world = new Game(4);
			//FP.console.enable();
		}
		
		
		override public function render():void 
		{
			var color:uint = 0x00000000;
			if (blink)
			{
				blinkProgress += 0.1;
				color = FP.colorLerp(0x00000000, 0xFFFF0000, blinkProgress<0?Math.abs(1+blinkProgress):(1.0-blinkProgress));
				
				if (blinkProgress > 1.0)
				{
					blink = false;
					blinkProgress = -1.0;
				}
			} else
			if (fade)
			{
				fadeProgress += 0.1;
				if (fadeProgress > 1.0)
				{
					fadeProgress = 1.0;
				}
				
				color = FP.colorLerp(0x00000000, fadeDestColor, fadeProgress);
				
				if (fadeProgress >= 1.0)
				{
					overlay.bitmapData.fillRect(overlay.bitmapData.rect, color);
					fade = false;
					fadeProgress = 0;
					fadeCallback();
				}
			}
			
			overlay.bitmapData.fillRect(overlay.bitmapData.rect, color);
			super.render();
		}
		
	}
	
}