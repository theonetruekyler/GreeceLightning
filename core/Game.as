package core {			
	import interfaces.iState;
	import states.Tutorial;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import states.Menu;
	import states.Play;
	//import states.GameOver;
	import states.ChooseLevel;
	import states.About;
	
	/**
	 * ...
	 * @author kyler thompson, aaron howland
	 */
	
	public class Game extends Sprite {
		// constants representing game states
		public static const MENU_STATE:int = 0;
		public static const PLAY_STATE:int = 1;
		public static const CHOOSE_LEVEL_STATE:int = 3;
		public static const ABOUT_STATE:int = 4;
		public static const TUTORIAL_STATE:int = 5;
		
		private var current_state:iState;
		
		public function Game() {
			Assets.init();
			Maps.init();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void {
			changeState(MENU_STATE);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function changeState(state:int):void {
			if(current_state != null) {
				current_state.destroy();
				current_state = null;
			}
			switch(state) {
				case MENU_STATE:
					current_state = new Menu(this);
					break;
				case PLAY_STATE:
					current_state = new Play(this);
					break;
				case ABOUT_STATE:
					current_state = new About(this);
					break;
				case CHOOSE_LEVEL_STATE:
					current_state = new ChooseLevel(this);
					break;
				case TUTORIAL_STATE:
					current_state = new Tutorial(this);
					break;
			}
			addChild(Sprite(current_state));
		}
		
		private function update(event:Event):void {
			current_state.update();
		}
	}
}