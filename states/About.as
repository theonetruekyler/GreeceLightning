package states
{
	import core.Assets;
	import starling.display.Image;
	import core.Game;
	import starling.display.Sprite;
	import starling.events.Event;
	import interfaces.iState;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author AJ
	 */
	public class About extends Sprite implements iState
	{
		private var game:Game;
		private var bg:Image;
		private var scroll:Image;
		private var textField:TextField;
		
		
		public function About(game:Game)
		{
			this.game = game;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void
		{
			// add background to stage
			bg = new Image(Assets.getTexture("background"));
			this.addChild(bg);
			
			// add scroll to stage
			scroll = new Image(Assets.getTexture("scroll"));
			this.addChild(scroll);
			scroll.x = 145;
			
			// text
            textField = new TextField(800, 95, "About Greece Lightning", "Basileus", 30, 0x000000);
			textField.hAlign = "center";  // horizontal alignment
			textField.vAlign = "bottom"; // vertical alignment
			textField.border = false;
			this.addChild(textField);
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
	}
	
}