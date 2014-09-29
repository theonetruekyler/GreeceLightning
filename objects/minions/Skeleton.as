package objects.minions  {
	
	import core.Assets;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import libraries.CollisionDetection;
	import flash.utils.Timer;
	import interfaces.Minion;
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
	public class Skeleton extends Sprite implements Minion {
		// play state
		private var play_state:Play;
		// states
		private const STATE_MOVE:int = 0;
		private const STATE_WAIT:int = 1;
		private const STATE_ATCK:int = 2;
		private var state:int;
		// movieclips
		private var juggler:Juggler;
		private var skel_sr:Image;
		private var skel_mc_walk:MovieClip;
		private var skel_mc_attk:MovieClip;
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
		// target denizen
		private var tar_den:Denizen;
		// timers
		private var tmr_wait:Timer;
		private var tmr_dmg:Timer;
		private var en_dmg:Boolean;
		
		public function Skeleton(play_state:Play) {
			// initialize play_state
			this.play_state = play_state;
			// initialize when added to stage
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void {
			// initialize movieclips
			juggler = play_state.getJuggler();
			skel_sr = new Image(Assets.text_at.getTexture("minions/skeleton/still/skelSR"));
			skel_mc_walk = new MovieClip(Assets.text_at.getTextures("minions/skeleton/walking_right"), 4);
			skel_mc_attk = new MovieClip(Assets.text_at.getTextures("minions/skeleton/attack_right"), 4);
			skel_mc_attk.y = -20;
			// initialize hitboxes
			box_top = new Rectangle(5, 35, 40, 5);
			box_bot = new Rectangle(5, 66, 40, 5);
			box_lef = new Rectangle(0, 40, 25, 25);
			box_rit = new Rectangle(25, 40, 25, 25);
			// initialize attributes
			atr_pow = 1;
			atr_def = 3;
			atr_per = 100;
			vel_max = 2.0;
			nav_rng = 200;
			nav_pos = new Point();
			nav_des = new Point();
			tar_den = null;
			// initialize timers
			tmr_wait = new Timer(2000, 1);
			tmr_wait.addEventListener(TimerEvent.TIMER, timerFunc);
			tmr_dmg = new Timer(1000);
			tmr_dmg.addEventListener(TimerEvent.TIMER, timerFunc);
			en_dmg = true;
			// initialize healthbar
			hb = new Healthbar(atr_def);
			hb.pivotX = hb.width * 0.5;
			hb.pivotY = hb.height;
			hb.x = 25;
			hb.y = -5;
			addChild(hb);
			// start state machine
			changeState(STATE_MOVE);
		}
		
		public function getDestination():Point {
			return nav_des;
		}
		
		public function setDestination(pnt:Point):void {
			// update position
			nav_pos.setTo(x, y);
			// set destination
			nav_des = pnt;
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
			/*
			var locBound:Rectangle = CollisionDetection.rectGlobalToLocal(bound, this);
			if (locBound.intersects(top_box) || locBound.intersects(bot_box)) {
				this.y += -velY;
				// reenter move state
				changeState(state_move);
			}
			else if (locBound.intersects(rit_box) || locBound.intersects(lef_box)) {
				this.x += -velX;
				// reenter move state
				changeState(state_move);
			}
			*/
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
		
		// search for nearby denizens
		private function seekDenizen():void {
			var denizens:Vector.<Denizen> = play_state.getLevelManager().getDenizens();
			// for each denizen
			for (var i:int = 0; i < denizens.length; i++) {
				// are they within 100 pixels?
				if (CollisionDetection.radCollide(this, denizens[i], play_state.getLevelManager(), atr_per)) {
					// set target denizen
					tar_den = denizens[i];
					// set a course
					setDestination(new Point(denizens[i].x, denizens[i].y));
					break;
				}
			}
		}
		
		// called every frame of a move state
		private function move():void {
			// distance between destination and current position
			nav_pos.setTo(x, y);
			var dis:Point = nav_des.subtract(nav_pos);
			// destination reached, enter wait state
			if (Math.sqrt(Math.pow(dis.x, 2) + Math.pow(dis.y, 2)) < vel_max) {
				// enter wait state
				changeState(STATE_WAIT);
			}
			// keep moving
			else {
				// search for denizens
				//if (tar_den == null) {
					seekDenizen();
				//}
				// move
				x += vel_x;
				y += vel_y;
			}
		}
		
		// called every frame of a wait state
		private function wait():void {
			// does nothing
		}
		
		// called every frame of an attack state
		private function attack(tar_den:Denizen):void {
			// target denizen is alive
			if (tar_den.isAlive()) {
				if (en_dmg) {	
					tar_den.takeDamage(atr_pow);
					en_dmg = false;
					tmr_dmg.start();
				}
			}
			// target denizen is dead
			else {
				tar_den = null;
				changeState(STATE_MOVE);
			}
		}
		
		private function changeState(state_next:int):void {
			state = state_next;
			if (state_next == STATE_MOVE) {
				// current location
				nav_pos.setTo(x, y);
				// next location (random)
				var dx:Number = 50 + (Math.random() * nav_rng);
				if (Math.random() > 0.50) { dx = -dx; }
				dx += x;
				var dy:Number = 50 + (Math.random() * nav_rng);
				if (Math.random() > 0.50) { dy = -dy; }
				dy += y;
				nav_des.setTo(dx, dy);
				// calculate velocities
				var vel:Point = nav_des.subtract(nav_pos);
				vel.normalize(vel_max);
				vel_x = vel.x;
				vel_y = vel.y;
			}
			else if (state_next == STATE_WAIT) {
				// move sprites to nearest pixel
				justifySprites();
				// start timer
				tmr_wait.start();
			}
			else if (state_next == STATE_ATCK) {
				justifySprites();
			}
			// adjust sprites
			changeSprites();
		}
		
		// align sprites to nearest pixel
		private function justifySprites():void {
			this.x = Math.floor(x);
			this.y = Math.floor(y);
		}
		
		// change sprites
		private function changeSprites():void {
			// remove all animations
			juggler.remove(skel_mc_walk);
			juggler.remove(skel_mc_attk);
			removeChildren();
			// replace health bar
			addChild(hb);
			if (state == STATE_WAIT) {
				if (vel_x > 0) {
					skel_sr.scaleX = 1.0;
					skel_sr.x = 0;
					addChild(skel_sr);
				}
				else {
					skel_sr.scaleX = -1.0;
					skel_sr.x = skel_sr.width;
					addChild(skel_sr);
				}
			}
			else if (state == STATE_MOVE) {
				juggler.add(skel_mc_walk);
				if (vel_x > 0) {
					skel_mc_walk.scaleX = 1.0;
					skel_mc_walk.x = 0;
					addChild(skel_mc_walk);
				}
				else {
					skel_mc_walk.scaleX = -1.0;
					skel_mc_walk.x = skel_mc_walk.width;
					addChild(skel_mc_walk);
				}
			}
			else if (state == STATE_ATCK) {
				juggler.add(skel_mc_attk);
				if (vel_x > 0) {
					skel_mc_attk.scaleX = 1.0;
					skel_mc_attk.x = -14;
					addChild(skel_mc_attk);
				}
				else {
					skel_mc_attk.scaleX = -1.0;
					skel_mc_attk.x = 59;
					addChild(skel_mc_attk);
				}
			}
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
		}
		
		public function update():void {
			//seekDenizen();
			if (state == STATE_MOVE) {
				move();
			}
			else if (state == STATE_WAIT) {
				wait();
			}
			else if (state == STATE_ATCK) {
				attack(tar_den);
			}
		}
		
		public function destroy():void {
			// remove event listeners
			removeEventListener(Event.ADDED_TO_STAGE, init);
			tmr_wait.removeEventListener(TimerEvent.TIMER, timerFunc);
			// remove and destroy all children
			while (numChildren > 0) { removeChildAt(0, true); }
			// remove self from level manager's array
			var index:int = play_state.getLevelManager().getMinsSkel().lastIndexOf(this);
			play_state.getLevelManager().getMinsSkel().splice(index, 1);
			// remove from parent, destroy self
			removeFromParent(true);
		}
	}
}