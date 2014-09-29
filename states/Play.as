package states {
	import core.Assets;
	import core.Game;
	import core.Maps;
	import flash.geom.Vector3D;
	import interfaces.Minion;
	import starling.text.TextField;
	import starling.animation.Juggler;
	import flash.geom.Point;
	import interfaces.iState;
	import managers.CollisionManager;
	import managers.LevelManager;
	import objects.minions.Skeleton;
	import objects.minions.Minotaur;
	import objects.minions.Pit;
	import objects.ui.PauseMenu;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.lightning.*;
	import starling.filters.BlurFilter;
	import starling.filters.FragmentFilterMode;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import starling.display.Image;
	import flash.filters.GlowFilter;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class Play extends Sprite implements iState {
		// the game
		private var game:Game;
		// paused button, menu, and variable
		private var pauseMenu:PauseMenu;
		private var pauseButton:Button;
		private var isPaused:Boolean;
		// width and height of original, non-scaled window
		private const SCREEN_WIDTH:uint = 800;
		private const SCREEN_HEIGHT:uint = 480;
		// managers
		private var colMan:CollisionManager;
		private var levMan:LevelManager;
		// juggler
		private var juggler:Juggler;
		// lightning
		private static const COLOR:uint = 0xDDEEFF;
		private var strikeArray:Vector.<Lightning>;
		// attack constans
		private static const ATTACK_STD:int = 0;
		private static const ATTACK_AOE:int = 1;
		private var attackType:int;
		
		// <AJ> timers
		private var loadTimer:Timer = new Timer(7000, 1);
		private var myTimer:Timer = new Timer(1000, 0)
		private var timer2:Timer = new Timer (1500, 1)
		// game over
		private var gameOver:TextField;
		// game over buttons
		private var retry:Button;
		private var exit:Button;
		// glow filter
		private var glowFilter:GlowFilter;
		// </AJ>
			
		public function Play(game:Game) {
			this.game = game;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void {
			Mouse.cursor = "button";
			// remove event listener
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			// add touch event listener
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			// init level manager
			levMan = new LevelManager(this);
			addChild(levMan);
			// init collision manager
			colMan = new CollisionManager(this);
			// init strikeArray
			strikeArray = new Vector.<Lightning>();
			attackType = ATTACK_STD;
			// initialize juggler
			juggler = new Juggler();
			Starling.juggler.add(juggler);
			// load map
			levMan.mapLoad("../maps/level_alpha.tmx");
			// initializations for pause
			pauseButton = new Button(Assets.text_at.getTexture("buttons/scroll_closed"));
			pauseButton.x = SCREEN_WIDTH - pauseButton.width;
			//pauseButton.y = SCREEN_HEIGHT - pauseButton.height;
			addEventListener(Event.TRIGGERED, pauseGame);
			addChild(pauseButton);
			pauseMenu = new PauseMenu(this);
			pauseMenu.x = SCREEN_WIDTH * 0.5;
			pauseMenu.y = SCREEN_HEIGHT * 0.5;
			isPaused = false;
			
			// <AJ/> Gameover splash
            gameOver = new TextField(800, 250, "", "Basileus", 190, 0xffffff);
			gameOver.hAlign = "center";  // horizontal alignment
			gameOver.vAlign = "bottom"; // vertical alignment
			gameOver.border = false;
			glowFilter = new GlowFilter(0x009900,1,10,10,10);
			gameOver.nativeFilters = [glowFilter];
			// retry button
			retry = new Button((Assets.getTexture(("scrollButton"))));
			retry.x = 250;
			retry.y = 285;
			retry.fontName = "Basileus";
			retry.fontSize = 34;
			retry.text = "Retry";
			// play button
			exit = new Button((Assets.getTexture(("scrollButton"))));
			exit.x = 420;
			exit.y = 285;
			exit.fontName = "Basileus";
			exit.fontSize = 42;
			exit.text = "Exit";
			//myTimer for checking game over
			loadTimer.start();
			loadTimer.addEventListener(TimerEvent.TIMER, loadingWait);
			// </AJ>
		}
		
		// <AJ/>
		private function loadingWait(event:TimerEvent):void
		{
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER, timerHandle);
		}
		
		// <AJ/> 
		private function timerHandle(event:TimerEvent):void
		{ 
			// winner splash screen
			if (levMan.minionsDead()) {
				trace("Game Over!");
				gameOver.text = "Victory";
				removeChild(pauseButton);
				timer2.start();
				timer2.addEventListener(TimerEvent.TIMER, timerHandle2);
				addChild(gameOver);
				myTimer.stop();
			}
			//loser splash screen
			if (levMan.denizensDead()) {
				trace("Game Over!");
				gameOver.text = "Defeat";
				glowFilter.color = 0xff0000;
				removeChild(pauseButton);
				timer2.start();
				timer2.addEventListener(TimerEvent.TIMER, timerHandle2);
				addChild(gameOver);
				myTimer.stop();
			}
		}
		// <AJ/> adds retry and exit buttons after 1.25 seconds on game over screen
		private function timerHandle2(event:TimerEvent):void {
			addChild(retry);
			addChild(exit);
			timer2.stop();
		}
		
		// do things
		public function update():void {
			// if the game isn't paused...
			if (!isPaused) {
				levMan.update();
				colMan.update();
				updateLightning();
			}
		}
		
		// update each lightning strike
		private function updateLightning():void {
			for each (var lightning:Lightning in strikeArray) {
				lightning.update();
			}
		}
		
		private function newLightning(posX:Number, posY:Number):Lightning {
			// initialize new lightning
			var lightning:Lightning = new Lightning(COLOR, 3);
			lightning.childrenDetachedEnd = false;
			lightning.childrenLifeSpanMin = 0.1;
			lightning.childrenLifeSpanMax = 0.5;
			lightning.childrenMaxCount = 3;
			lightning.childrenMaxCountDecay = 0.5;
			lightning.steps = 30;
			lightning.alphaFadeType = LightningFadeType.NONE;
			lightning.childrenProbability = 0.2;
			lightning.startX = posX;
			lightning.endX = posX;
			lightning.startY = 0;
			lightning.endY = posY;
			// push new lightning unto strikeArray
			strikeArray.push(lightning);
			// return new lightning
			return lightning;
		}
		
		// touch event handler
		private function onTouch(event:TouchEvent):void {
			var touches:Vector.<Touch> = event.getTouches(this);
			for each (var touch:Touch in touches) {
				// finger swipes
				if (touch.phase == TouchPhase.MOVED) {
					// <AJ> Mouse.cursor = "hand"; <AJ/>
					// lightning "off" ?
					// <implementation/>
					// calculate scrolling velocity
					var velX:int = Math.round(touch.getMovement(this).x * 0.70);
					var velY:int = Math.round(touch.getMovement(this).y * 0.70);
					var newPosX:int = levMan.x + velX;
					var newPosY:int = levMan.y + velY;
					// move map, but never into the aether
					if (newPosX < 0 && newPosX > -(levMan.width - SCREEN_WIDTH)) {
						levMan.x += velX;
					}
					if (newPosY < 0 && newPosY > -(levMan.height - SCREEN_HEIGHT)) {
						levMan.y += velY;
					}
				}
				// finger taps
				else if (touch.phase == TouchPhase.BEGAN) {
					// <AJ> Mouse.cursor = "button"; </AJ>
					var j:int;
					// get coordinates of touch, instantiate and add lightning
					var localPos:Point = touch.getLocation(this);
					addChild(newLightning(localPos.x, localPos.y));
					// get skeleton vector
					var mins_skel:Vector.<Skeleton> = levMan.getMinsSkel();
					for each (var skel:Skeleton in mins_skel) {
						// check if the touch occured w/in the minion's bounds
						if (skel.getBounds(this).containsPoint(localPos)) {
							// call the minion's onTouch method
							skel.onTouch();
							break;
						}
					}
					// get minotaur vector
					var mins_mino:Vector.<Minotaur> = levMan.getMinsMino();
					for each (var mino:Minotaur in mins_mino) {
						// check if the touch occured w/in the minion's bounds
						if (mino.getBounds(this).containsPoint(localPos)) {
							// call the minion's onTouch method
							mino.onTouch();
							break;
						}
					}
					// get pit vector
					var mins_pit:Vector.<Pit> = levMan.getMinsPit();
					for each (var pit:Pit in mins_pit) {
						// check if the touch occured w/in the minion's bounds
						if (pit.getBounds(this).containsPoint(localPos)) {
							// call the minion's onTouch method
							pit.onTouch();
							break;
						}
					}
				}
				// finger lifts
				else if (touch.phase == TouchPhase.ENDED) {
					// <AJ> Mouse.cursor = "button"; </AJ>
					removeChild(strikeArray.pop());
					//strikeArray.pop();
				}
			}
		}
		
		public function getGameInstance():Game {
			return game;
		}
		
		public function getCollisionManager():CollisionManager {
			return colMan;
		}
		
		public function getLevelManager():LevelManager {
			return levMan;
		}
		
		public function getJuggler():Juggler {
			return juggler;
		}
		
		// handles button event
		public function pauseGame(event:Event):void {
			if (event.target ==	pauseButton) {
				if (!isPaused) {	
					addChild(pauseMenu);
					Starling.juggler.remove(juggler);
					removeEventListener(TouchEvent.TOUCH, onTouch);
					isPaused = true;
				} else {
					removeChild(pauseMenu);
					Starling.juggler.add(juggler);
					addEventListener(TouchEvent.TOUCH, onTouch);
					isPaused = false;
				}
			}
			if (event.target == retry) {
				game.changeState(Game.PLAY_STATE);
			}
			if (event.target == exit) {
				game.changeState(Game.CHOOSE_LEVEL_STATE);
			}
		}
		
		public function destroy():void {
			// remove and destroy level manager
			levMan.destroy();
			removeChild(levMan);
			//levMan = null;
			// remove and destroy pause menu
			pauseMenu.destroy();
			removeChild(pauseMenu, true);
			pauseMenu = null;
			// remove and destroy pause button
			removeChild(pauseButton, true);
			pauseButton = null;
			// remove and destroy lightning
			strikeArray.splice(0, strikeArray.length);
			//removeChild(lightning);
			//lightning = null;
			//removeChild(myTimer, true);
			loadTimer.removeEventListener(TimerEvent.TIMER, loadingWait);
			myTimer.removeEventListener(TimerEvent.TIMER, timerHandle);
			timer2.removeEventListener(TimerEvent.TIMER, timerHandle2);
			removeChild(gameOver);
			removeChild(exit);
			removeChild(retry);
			
		}
	}
}