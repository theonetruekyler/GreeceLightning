package states {
	import core.Assets;
	import core.Game;
	
	import interfaces.iState;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author aaron howland
	 */
	
	public class Menu extends Sprite implements iState{
		
		private var game:Game;
		private var bg:Image;
		private var play:Button;
		private var textField:TextField;
		private var footer:TextField;
		
		public function Menu(game:Game) {
			this.game = game;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void 
		{
			// add background to stage
			bg = new Image(Assets.getTexture("background"));
			this.addChild(bg);
			
			// title
            textField = new TextField(800, 90, "Greece Lightning", "Basileus", 95, 0xffffff);
			textField.hAlign = "center";  // horizontal alignment
			textField.vAlign = "bottom"; // vertical alignment
			textField.border = false;
			this.addChild(textField);
			var glowFilter:GlowFilter = new GlowFilter(0x000000,1,10,10,10);
			textField.nativeFilters = [glowFilter];
			
			// footer
            footer = new TextField(798, 480, "Kleptomaniac Games", "Basileus", 22, 0xffffff);
			footer.hAlign = "right";  // horizontal alignment
			footer.vAlign = "bottom"; // vertical alignment
			footer.border = false;
			this.addChild(footer);
			var glowFilter2:GlowFilter = new GlowFilter(0x000000,1,4,4,4);
			footer.nativeFilters = [glowFilter2];
			
			// playbutton
			play = new Button((Assets.getTexture(("scrollButton"))));
			play.x = 350;
			play.y = 150;
			play.fontName = "Basileus";
			play.fontSize = 42;
			play.text = "Play";
			this.addChild(play);
			
			// button listener
			this.addEventListener(Event.TRIGGERED, clickButton);
		}
		
		private function clickButton(event:Event):void {
			
			if ((event.target as Button) == play)
			{
				game.changeState(Game.CHOOSE_LEVEL_STATE);
			}
		}
		
		public function update():void {
			
		}
		
		public function destroy():void {
			
			// removes images & buttons from stage
			removeChild(play, true);
			removeChild(bg);
			removeChild(textField, true);
			removeChild(footer);
		}
		
	}

}