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
	
	public class ChooseLevel extends Sprite implements iState{
		
		private var game:Game;
		private var bg:Image;
		private var nova:Image;
		private var start:Button;
		private var exit:Button;
		private var left:Button;
		private var right:Button;
		private var tutorial:Button;
		private var textField:TextField;
		private var footer:TextField;
		private var city:TextField;
		private var book:Image;
		
		private var xCord:Array = new Array("218","174","185","261","194","195");
		private var yCord:Array = new Array("185", "192", "167", "262","187", "209");
		private var names:Array = new Array("Athens", "Olympia", "Delphi", "Knossos","Corinth","Sparta");
		private var count:int = 0;
		
		public function ChooseLevel(game:Game) {
			this.game = game;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void 
		{
			// add background to stage
			bg = new Image(Assets.getTexture("background"));
			this.addChild(bg);
			
			// title
            textField = new TextField(800, 90, "Choose Level", "Basileus", 85, 0xffffff);
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
			
			// book
			book = new Image(Assets.getTexture("book"));
			book.x = 160;
			book.y = 110;
			this.addChild(book);
			
			// supernova
			nova = new Image(Assets.getTexture("supernova"));
			nova.x = 218;
			nova.y = 185;
			this.addChild(nova);
			
			// City
            city = new TextField(570, 185, "Athens", "Basileus", 48);
			city.hAlign = "right";  // horizontal alignment
			city.vAlign = "bottom"; // vertical alignment
			city.border = false;
			this.addChild(city);
			
			// start game button
			start = new Button((Assets.getTexture(("scrollButton"))));
			start.x = 650;
			start.y = 130;
			start.fontName = "Basileus";
			start.fontSize = 33;
			start.text = "Start";
			start.textVAlign = "center";
			this.addChild(start);
			
			// tutorial button
			tutorial = new Button((Assets.getTexture(("scrollButton"))));
			tutorial.x = 20;
			tutorial.y = 360;
			tutorial.fontName = "Basileus";
			tutorial.fontSize = 22;
			tutorial.text = "Tutorial";
			tutorial.textVAlign = "center";
			this.addChild(tutorial);
			
			// exit button
			exit = new Button((Assets.getTexture(("exit"))));
			exit.x = 587;
			exit.y = 395;
			exit.alpha = 0;
			this.addChild(exit);
			
			// left button
			left = new Button((Assets.getTexture(("left"))));
			left.x = 440;
			left.y = 240;
			this.addChild(left);
			
			// right button
			right = new Button((Assets.getTexture(("right"))));
			right.x = 530;
			right.y = 240;
			this.addChild(right);
			
			// button listener
			this.addEventListener(Event.TRIGGERED, clickButton);
		}
		
		private function clickButton(event:Event):void {
			
			if ((event.target as Button) == start)
			{
				game.changeState(Game.PLAY_STATE);
			}
			if ((event.target as Button) == tutorial)
			{
				game.changeState(Game.TUTORIAL_STATE);
			}
			if ((event.target as Button) == exit)
			{
				game.changeState(Game.MENU_STATE);
			}
			if ((event.target as Button) == left)
			{
				if (count > 0) {
					count--;
				}
				
				 nova.x = xCord[count];
				 nova.y = yCord[count];
				 city.text = names[count];
			}
			if ((event.target as Button) == right)
			{
				 if (count < (xCord.length - 1)) {
					count++;
				 }
				 
				 nova.x = xCord[count];
				 nova.y = yCord[count];
				 city.text = names[count];
			}
			
			
		}
		
		public function update():void {
			
		}
		
		public function destroy():void {
			
			// removes images & buttons from stage
			removeChild(start, true);
			removeChild(bg);
			removeChild(textField, true);
			removeChild(footer);
			removeChild(book, true);
			removeChild(exit, true);
			removeChild(left, true);
			removeChild(right, true);
			removeChild(nova, true);
			removeChild(city, true);
			removeChild(tutorial, true);
		}
		
	}

}