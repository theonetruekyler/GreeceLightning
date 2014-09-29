package states
{
	import core.Assets;
	import starling.display.Button;
	import starling.display.Image;
	import core.Game;
	import starling.display.Sprite;
	import starling.events.Event;
	import interfaces.iState;
	import starling.text.TextField;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author AJ
	 */
	public class Tutorial extends Sprite implements iState
	{
		private var game:Game;
		private var bg:Image;
		private var scroll:Image;
		private var textField:TextField;
		private var title:TextField;
		private var title2:TextField;
		private var textField2:TextField;
		private var back:Button;
		private var footer:TextField;
		private var bigTitle:TextField;
		
		
		public function Tutorial(game:Game)
		{
			this.game = game;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void
		{
			// add background to stage
			bg = new Image(Assets.getTexture("background"));
			this.addChild(bg);
			
			// title
            bigTitle = new TextField(800, 90, "Tutorial", "Basileus", 85, 0xffffff);
			bigTitle.hAlign = "center";  // horizontal alignment
			bigTitle.vAlign = "bottom"; // vertical alignment
			bigTitle.border = false;
			this.addChild(bigTitle);
			var glowFilter:GlowFilter = new GlowFilter(0x000000,1,10,10,10);
			bigTitle.nativeFilters = [glowFilter];
			
			// add scroll to stage
			scroll = new Image(Assets.getTexture("scroll"));
			this.addChild(scroll);
			scroll.x = 145;
			scroll.y = 30;
			
			// Controls title
            title = new TextField(800, 195, "Controls", "Basileus", 40, 0x000000);
			title.hAlign = "center";  // horizontal alignment
			title.vAlign = "bottom"; // vertical alignment
			title.border = false;
			this.addChild(title);
			
			// Goal title
            title2 = new TextField(800, 285, "Goal", "Basileus", 40, 0x000000);
			title2.hAlign = "center";  // horizontal alignment
			title2.vAlign = "bottom"; // vertical alignment
			title2.border = false;
			this.addChild(title2);
			
			// Control text
            textField = new TextField(800, 230, "Zap the enemies using your mouse.", "Basileus", 24, 0x000000);
			textField.hAlign = "center";  // horizontal alignment
			textField.vAlign = "bottom"; // vertical alignment
			textField.border = false;
			this.addChild(textField);
			
			// Goal text
            textField2 = new TextField(800, 340, "Keep as many citizens alive as\n possible and eliminate all the enemies.", "Basileus", 22, 0x000000);
			textField2.hAlign = "center";  // horizontal alignment
			textField2.vAlign = "bottom"; // vertical alignment
			textField2.border = false;
			this.addChild(textField2);
			
			// footer
            footer = new TextField(798, 480, "Kleptomaniac Games", "Basileus", 22, 0xffffff);
			footer.hAlign = "right";  // horizontal alignment
			footer.vAlign = "bottom"; // vertical alignment
			footer.border = false;
			this.addChild(footer);
			var glowFilter2:GlowFilter = new GlowFilter(0x000000,1,4,4,4);
			footer.nativeFilters = [glowFilter2];
			
			// tutorial button
			back = new Button((Assets.getTexture(("scrollButton"))));
			back.x = 20;
			back.y = 360;
			back.fontName = "Basileus";
			back.fontSize = 36;
			back.text = "Back";
			back.textVAlign = "center";
			this.addChild(back);
			
			// button listener
			this.addEventListener(Event.TRIGGERED, clickButton);
			
		}
		
		public function clickButton(event:Event):void {
			
			if ((event.target as Button) == back)
			{
				game.changeState(Game.CHOOSE_LEVEL_STATE);
			}
		}
		
		public function update():void
		{
			
		}
		
		public function destroy():void
		{
			// removes images & buttons from stage
			removeChild(bg);
			removeChild(scroll, true);
			removeChild(textField, true);
			removeChild(textField2, true);
			removeChild(back, true);
			removeChild(footer);
			removeChild(title, true);
			removeChild(title2, true);
			removeChild(bigTitle, true);
			
		}
	}
	
}