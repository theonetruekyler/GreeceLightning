package objects.minions  {
	
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
	public class Pit extends Sprite implements Minion {
		private var play_state:Play;
		// movieclips
		private var juggler:Juggler;
		private var pit_mc_flow:MovieClip;
		// attributes
		private var atr_def:int;
		private var hb:Healthbar;
		// timers
		private var tmr_spwn:Timer;
		
		public function Pit(play_state:Play) {
			this.play_state = play_state;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void {
			// initialize movieclips
			juggler = play_state.getJuggler();
			pit_mc_flow = new MovieClip(Assets.text_at.getTextures("minions/pit"), 2);
			// initialize attributes
			atr_def = 30;
			// initialize healthbar
			hb = new Healthbar(atr_def);
			hb.pivotX = hb.width * 0.5;
			hb.pivotY = hb.height;
			hb.x = pit_mc_flow.width * 0.5;
			hb.y = -5;
			addChild(hb);
			// add movieclip
			juggler.add(pit_mc_flow);
			addChild(pit_mc_flow);
			// move this to bottom of display list
			play_state.getLevelManager().setChildIndex(this , 4);
			// initialize timer
			tmr_spwn = new Timer(3000);
			tmr_spwn.addEventListener(TimerEvent.TIMER, spawn);
			tmr_spwn.start();
		}
		
		private function spawn(event:TimerEvent):void {
			// get minion vectors
			var mins_skel:Vector.<Skeleton> = play_state.getLevelManager().getMinsSkel();
			var mins_mino:Vector.<Minotaur> = play_state.getLevelManager().getMinsMino();
			// check for minotaur
			var isMino:Boolean = true;
			if (mins_mino.length == 0) { isMino = false; }
			// spawn minion
			if (!isMino) {
				// new minotaur
				var mino:Minotaur = new Minotaur(play_state);
				mino.x = this.x; mino.y = this.y;
				mins_mino.push(mino);
				// add minion to level manager
				play_state.getLevelManager().addChild(mino);
			} else if (mins_skel.length + mins_mino.length < 30) {
				// new skeleton
				var skel:Skeleton = new Skeleton(play_state);
				skel.x = this.x; skel.y = this.y;
				mins_skel.push(skel);
				// add minion to level manager
				play_state.getLevelManager().addChild(skel);
			}
			// restart timer
			tmr_spwn.reset()
			tmr_spwn.start();
		}
		
		public function onTouch():void {
			hb.update(atr_def += -1);
			if (atr_def <= 0) {
				this.destroy();
			}
		}
		
		// functions required by Minion interface
		public function getDestination():Point { return new Point(this.x, this.y); }
		public function setDestination(pnt:Point):void { }
		public function onBoundCollision(bound:Rectangle):void { }
		public function onDenizenCollision():void { }
		public function update():void { }
		
		public function destroy():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			tmr_spwn.removeEventListener(TimerEvent.TIMER, spawn);
			// remove and destroy all children
			while (numChildren > 0) { removeChildAt(0, true); }
			// remove self from level manager's array
			var index:int = play_state.getLevelManager().getMinsPit().lastIndexOf(this);
			play_state.getLevelManager().getMinsPit().splice(index, 1);
			// remove from parent, destroy self
			removeFromParent(true);
		}
	}
}