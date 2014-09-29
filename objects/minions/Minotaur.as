package objects.minions 
{
	import core.Assets;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import interfaces.Minion;
	import libraries.CollisionDetection;
	import flash.utils.Timer;
	import objects.denizens.Denizen;
	import objects.ui.Healthbar;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import states.Play;
	
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class Minotaur extends Sprite implements Minion {
		private var play_state:Play;
		// states
		public const STATE_MOVE:int = 0;
		public const STATE_WAIT:int = 1;
		public const STATE_ATCK:int = 2;
		public const STATE_CMND:int = 3;
		private var state:int;
		// movieclips
		private var juggler:Juggler;
		private var mino_sr:Image;
		private var mino_mc_walk:MovieClip;
		private var mino_mc_attk:MovieClip;
		private var mino_mc_cmnd:MovieClip;
		// emoji
		private var cmnd_em:Image;
		// hitboxes
		private var box_top:Rectangle;
		private var box_bot:Rectangle;
		private var box_rit:Rectangle;
		private var box_lef:Rectangle;
		// attributes
		private var atr_pow:int;
		private var atr_def:int;
		private var atr_per:int;
		private var hb:Healthbar;
		// velocities
		private var vel_max:Number;
		private var vel_x:Number;
		private var vel_y:Number;
		// range, position, destination
		private var nav_rng:Number;
		private var nav_pos:Point;
		private var nav_des:Point;
		// variable for target denizen
		private var tar_min:Minion;
		private var tar_den:Denizen;
		private var den_pos:Point;
		// variables for timer
		private var tmr_wait:Timer;
		private var tmr_cmnd:Timer;
		private var tmr_dmg:Timer;
		private var en_dmg:Boolean;
		
		public function Minotaur(play_state:Play) {
			this.play_state = play_state;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void {
			// initialize movieclips
			juggler = play_state.getJuggler();
			mino_sr = new Image(Assets.text_at.getTexture("minions/minotaur/still/Minotaur"));
			mino_mc_walk = new MovieClip(Assets.text_at.getTextures("minions/minotaur/walking_right"), 4);
			mino_mc_attk = new MovieClip(Assets.text_at.getTextures("minions/minotaur/attacking_right"), 6);
			mino_mc_cmnd = new MovieClip(Assets.text_at.getTextures("minions/minotaur/commanding_right"), 5);
			mino_mc_cmnd.y = -5;
			cmnd_em = new Image(Assets.text_at.getTexture("emojis/exclamation"));
			cmnd_em.pivotX = cmnd_em.width * 0.5;
			cmnd_em.pivotY = cmnd_em.height;
			cmnd_em.x = 25;
			cmnd_em.y = 2;
			// initialize hitboxes
			box_top = new Rectangle(5, 42, 32, 5);
			box_bot = new Rectangle(5, 78, 32, 5);
			box_lef = new Rectangle(0, 47, 21, 31);
			box_rit = new Rectangle(21, 47, 21, 31);
			// initialize attributes
			atr_pow = 5;
			atr_def = 15;
			atr_per = 200;
			vel_max = 1.0;
			nav_rng = 300;
			nav_pos = new Point();
			nav_des = new Point();
			den_pos = new Point();
			// initialize healthbar
			hb = new Healthbar(atr_def);
			hb.pivotX = hb.width * 0.5;
			hb.pivotY = hb.height;
			hb.x = 25;
			hb.y = -5;
			// initialize timers
			tmr_wait = new Timer(2000, 1);
			tmr_wait.addEventListener(TimerEvent.TIMER, timerFunc);
			tmr_dmg = new Timer(1000);
			tmr_dmg.addEventListener(TimerEvent.TIMER, timerFunc);
			en_dmg = true;
			tmr_cmnd = new Timer(2000, 1);
			tmr_cmnd.addEventListener(TimerEvent.TIMER, timerFunc);
			// start state machine
			changeState(STATE_MOVE);
		}
		
		public function getDestination():Point {
			return nav_des;
		}
		
		public function setDestination(pnt:Point):void {
			// set destination
			nav_des = pnt;
			// update position
			nav_pos.setTo(x, y);
			// update velocities
			var vel:Point = nav_des.subtract(nav_pos);
			vel.normalize(vel_max);
			vel_x = vel.x;
			vel_y = vel.y;
			// change sprites
			changeSprites();
		}
		
		public function onTouch():void {
			hb.update(atr_def += -1);
			if (atr_def <= 0) {
				this.destroy();
			}
		}
		
		// "I've hit an obstacle, now what?"
		public function onBoundCollision(bound:Rectangle):void {
			// turn around
			this.x += -vel_x;
			this.y += -vel_y;
			changeState(STATE_MOVE);
		}
		
		public function onDenizenCollision(den:Denizen):void {
			// more precise collision detection
			if (CollisionDetection.rectCollide(box_lef, den, this) || CollisionDetection.rectCollide(box_rit, den, this)) {	
				// set target denizen
				tar_den = den;
				// enter attack state
				changeState(STATE_ATCK);
			}
		}
		
		// change necessary variables for state transition
		private function changeState(nextState:int):void {
			state = nextState;
			// variable adjustments for state transitions
			if (nextState == STATE_MOVE) {
				// if mino can't find a denizen
				if (!seekDenizen()) {
					// generate next location (random)
					var dx:Number = 50 + (Math.random() * nav_rng);
					if (Math.random() > 0.50) { dx = -dx; }
					dx += x;
					var dy:Number = 50 + (Math.random() * nav_rng);
					if (Math.random() > 0.50) { dy = -dy; }
					dy += y;
					// set destination
					setDestination(new Point(dx, dy));
				}
			}
			else if (nextState == STATE_WAIT) {
				tmr_wait.start();
			}
			else if (nextState == STATE_ATCK) {
				// do nothing?
			}
			else if (nextState == STATE_CMND) {
				tmr_cmnd.start();
			}
			justifySprites();
			changeSprites();
		}
		
		private function changeSprites():void {
			// remove all animations
			juggler.remove(mino_mc_walk);
			juggler.remove(mino_mc_attk);
			juggler.remove(mino_mc_cmnd);
			removeChildren();
			// replace health bar
			addChild(hb);
			if (state == STATE_WAIT) {
				if (vel_x > 0) {
					mino_sr.scaleX = 1.0;
					mino_sr.x = 0;
					addChild(mino_sr);
				}
				else {
					mino_sr.scaleX = -1.0;
					mino_sr.x = mino_sr.width;
					addChild(mino_sr);
				}
			}
			else if (state == STATE_MOVE) {
				juggler.add(mino_mc_walk);
				if (vel_x > 0) {
					mino_mc_walk.scaleX = 1.0;
					mino_mc_walk.x = 0;
					addChild(mino_mc_walk);
				}
				else {
					mino_mc_walk.scaleX = -1.0;
					mino_mc_walk.x = mino_mc_walk.width;
					addChild(mino_mc_walk);
				}
			}
			else if (state == STATE_ATCK) {
				juggler.add(mino_mc_attk);
				if (vel_x > 0) {
					mino_mc_attk.scaleX = 1.0;
					mino_mc_attk.x = -32;
					addChild(mino_mc_attk);
				}
				else {
					mino_mc_attk.scaleX = -1.0;
					mino_mc_attk.x = 83;
					addChild(mino_mc_attk);
				}
			}
			else if (state == STATE_CMND) {
				juggler.add(mino_mc_cmnd);
				if (vel_x > 0) {
					mino_mc_cmnd.scaleX = 1.0;
					mino_mc_cmnd.x = -32;
					addChild(mino_mc_cmnd);
				}
				else {
					mino_mc_cmnd.scaleX = -1.0;
					mino_mc_cmnd.x = 83;
					addChild(mino_mc_cmnd);
				}
				addChild(cmnd_em);
			}
		}
		
		// align sprites to nearest pixel
		private function justifySprites():void {
			x = Math.floor(x);
			y = Math.floor(y);
		}
		
		private function seekDenizen():Boolean {
			var denizens:Vector.<Denizen> = play_state.getLevelManager().getDenizens();
			// for each denizen
			for (var i:int = 0; i < denizens.length; i++) {
				// if denizen w/in perception
				if (CollisionDetection.radCollide(this, denizens[i], play_state.getLevelManager(), atr_per)) {
					// set target denizen
					tar_den = denizens[i];
					den_pos = new Point(tar_den.x, tar_den.y);
					// set destination
					setDestination(den_pos);
					// trace("d found");
					return true;
				}
			}
			return false;
		}
		
		private function seekMinion():Boolean {
			var mins_skel:Vector.<Skeleton> = play_state.getLevelManager().getMinsSkel();
			// for each minion
			for (var i:int; i < mins_skel.length; i++) {
				// if skeleton is w/in 100px
				if (CollisionDetection.radCollide(this, mins_skel[i], play_state.getLevelManager(), 50)) {
					// if skeleton's destination is not the target denizen
					//if (minions[i].getDestination().x != td_pos.x && minions[i].getDestination().y != td_pos.y) {
						// set target_minion
						tar_min = mins_skel[i];
						// trace("m found");
						return true;
					//}
				}
			}
			return false;
		}
		
		private function timerFunc(e:TimerEvent):void {
			if (e.target == tmr_wait) {
				changeState(STATE_MOVE);
				tmr_wait.reset();
			}
			else if (e.target == tmr_dmg) {
				en_dmg = true;
				tmr_dmg.reset();
			}
			else if (e.target == tmr_cmnd) {
				changeState(STATE_MOVE);
				tmr_cmnd.reset();
			}
		}
		
		// called every frame of a move state
		private function move():void {
			// update current location
			nav_pos.setTo(x, y)
			// find distance to destination
			var dis:Point = nav_des.subtract(nav_pos);
			if (Math.sqrt(Math.pow(dis.x, 2) + Math.pow(dis.y, 2)) < vel_max) {
				changeState(STATE_WAIT);
			} else {
				// try to command
				if (seekDenizen() && seekMinion()) {
					changeState(STATE_CMND);
				}
				// "keep moving"
				x += vel_x;
				y += vel_y;
			}
		}
		
		// called every frame of a wait state
		private function wait():void {
			// do nothing
		}
		
		// called every frame of a attack state
		private function attack(tar_den:Denizen):void {
			if (tar_den.isAlive() && tar_den != null) {
				if (en_dmg) {
					tar_den.takeDamage(atr_pow);
					en_dmg = false;
					tmr_dmg.start();
				}
			}
			else {
				tar_den = null;
				// change state
				changeState(STATE_MOVE);
			}
		}
		
		// called every frame of a command state
		private function command():void {
			if (seekMinion() && seekDenizen()) {
				var min_des:Point = tar_min.getDestination();
				if (min_des != den_pos) {
					tar_min.setDestination(den_pos);
				}
			}
		}
		
		public function update():void {
			if (state == STATE_MOVE) {
				move();
			}
			else if (state == STATE_WAIT) {
				wait();
			}
			else if (state == STATE_ATCK) {
				attack(tar_den);
			}
			else if (state == STATE_CMND) {
				command();
			}
		}
		
		public function destroy():void {
			// remove event listeners
			removeEventListener(Event.ADDED_TO_STAGE, init);
			tmr_wait.removeEventListener(TimerEvent.TIMER, timerFunc);
			tmr_dmg.removeEventListener(TimerEvent.TIMER, timerFunc);
			tmr_cmnd.removeEventListener(TimerEvent.TIMER, timerFunc);
			// remove and destroy all children
			while (numChildren > 0) { removeChildAt(0, true); }
			// remove self from level manager's array
			var index:int = play_state.getLevelManager().getMinsMino().lastIndexOf(this);
			play_state.getLevelManager().getMinsMino().splice(index, 1);
			// remove from parent, destroy self
			removeFromParent(true);
		}
	}
}