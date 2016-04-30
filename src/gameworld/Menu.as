package gameworld 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author me
	 */
	public class Menu extends World
	{
		private var text:Text;
		private var goodEnding:Boolean;
		
		public function Menu(goodEnding:Boolean = false ) 
		{
			this.goodEnding = goodEnding;
			
		}
		
		override public function begin():void 
		{
			super.begin();
			
			text = new Text("schroedinguy", 85, 75);
			text.scrollX = text.scrollY = 0;
			addGraphic(text);			
			
			if (true)
			{
				text = new Text("by puppetmaster for fgdc2", 85, 100,{size:8});
				text.scrollX = text.scrollY = 0;
				addGraphic(text);			
				
			}
			
			text = new Text("press any key", 105, 180,{size:8});
			text.scrollX = text.scrollY = 0;
			addGraphic(text);			
			
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.ANY))
			{
				FP.world = new Game(1);
			}
			
		}
	}

}