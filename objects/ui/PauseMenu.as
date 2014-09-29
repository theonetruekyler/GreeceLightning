package objects.ui {
	import core.Assets;
	import core.Game;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import states.Play;
	
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class PauseMenu extends Sprite {
		private var play_state:Play;
		
		private var exitToMain:Button;
		private var exitToMap:Button;
		
		public function PauseMenu(play_state:Play) {
			this.play_state = play_state;
			// button initializations
			exitToMain = new Button(Assets.text_at.getTexture("buttons/scroll_open"));
			exitToMain.text = "EXIT";
			exitToMain.fontSize = 24;
			addChild(exitToMain);
			
			exitToMap = new Button(Assets.text_at.getTexture("buttons/scroll_open"));
			exitToMap.text = "MAP";
			exitToMap.fontSize = 24;
			exitToMap.x = exitToMain.width + 10;
			addChild(exitToMap);
			// pivot adjustment
			this.pivotX = this.width * 0.5;
			this.pivotY = this.height * 0.5;
			// button push listener
			addEventListener(Event.TRIGGERED, buttonPressed);
		}
		
		private function buttonPressed(event:Event):void {
			if (event.target == exitToMain) {
				play_state.getGameInstance().changeState(Game.MENU_STATE);
			} else if (event.target == exitToMap) {
				play_state.getGameInstance().changeState(Game.CHOOSE_LEVEL_STATE);
			}
		}
		
		public function destroy():void {
			removeChild(exitToMain, true);
			exitToMain = null;
			removeChild(exitToMap, true);
			exitToMap = null;
		}
	}
}