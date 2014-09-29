package objects.denizens {
	import core.Assets;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import objects.ui.Healthbar;
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import states.Play;
	
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class Denizen extends Sprite {
		private var play_state:Play;
		// attributes
		private var atr_pow:int;
		private var atr_def:int;
		// 
		private var isDead:Boolean;
		private var isInvincible:Boolean;
		// textures and movieclips
		private var juggler:Juggler;
		private var pike_st:Image;
		private var pike_mc_hit:MovieClip;
		private var emj_hit:Image;
		// health bar
		private var hb:Healthbar;
		
		public function Denizen(play_state:Play) {
			this.play_state = play_state;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void {
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// attributes
			atr_pow = 0;
			atr_def = 10;
			isDead = false;
			isInvincible = false;
			// initialize healthbar
			hb = new Healthbar(atr_def);
			hb.pivotX = hb.width * 0.5;
			hb.pivotY = hb.height;
			hb.x = this.width * 0.5;
			hb.y = -hb.height;
			addChild(hb);
			// initialize images and movieclips
			juggler = play_state.getJuggler();
			pike_st = new Image(Assets.text_at.getTexture("denizens/pikeman/pikeSR"));
			pike_st.pivotX = pike_st.width * 0.5;
			pike_mc_hit = new MovieClip(Assets.text_at.getTextures("denizens/pikeman/pikeD"), 6);
			pike_mc_hit.pivotX = pike_mc_hit.width * 0.5;
			pike_mc_hit.x = -4;
			addChild(pike_st);
			// initialize emojis
			emj_hit = new Image(Assets.text_at.getTexture("emojis/grimace"));
			emj_hit.pivotX = emj_hit.width * 0.5;
			emj_hit.pivotY = emj_hit.height;
		}
		
		// return false if dead
		public function isAlive():Boolean {
			return !isDead;
		}
		
		private function die():void {
			isDead = true;
		}
		
		public function takeDamage(damage:int):void {
			hb.update(atr_def += -damage);
			if (atr_def <= 0) {
				this.die();
				this.destroy();
			} else {
				pike_mc_hit.addEventListener(Event.COMPLETE, mcOff);
				juggler.add(pike_mc_hit);
				removeChild(pike_st);
				addChild(pike_mc_hit);
				addChild(emj_hit);
			}
		}
		
		private function mcOff(e:Event):void {
			pike_mc_hit.removeEventListener(Event.COMPLETE, mcOff);
			juggler.remove(pike_mc_hit);
			removeChild(pike_mc_hit);
			removeChild(emj_hit);
			addChild(pike_st);
		}
		
		public function update():void {
			
		}
		
		public function destroy():void {
			if (pike_mc_hit.hasEventListener(Event.COMPLETE)) {
					pike_mc_hit.removeEventListener(Event.COMPLETE, mcOff);
			}
			// remove and destroy all children
			while (numChildren > 0) { removeChildAt(0, true); }
			// remove self from level manager's array
			var index:int = play_state.getLevelManager().getDenizens().lastIndexOf(this);
			play_state.getLevelManager().getDenizens().splice(index, 1);
			// remove from parent, destroy self
			removeFromParent(true);
		}
	}
}