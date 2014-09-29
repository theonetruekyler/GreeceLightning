package managers {
	//import flash.desktop.NotificationType;
	import flash.geom.Rectangle;
	import interfaces.Minion;
	import libraries.CollisionDetection;
	import objects.denizens.Denizen;
	import objects.minions.Minotaur;
	import objects.minions.Skeleton;
	import starling.display.Sprite;
	import states.Play;
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class CollisionManager {
		private var play_state:Play
		// denizen vector
		var dens:Vector.<Denizen>;
		// minion vectors
		var mins_skel:Vector.<Skeleton>;
		var mins_mino:Vector.<Minotaur>;
		// bounds vector
		var lvl_bounds:Vector.<Rectangle>;
		
		public function CollisionManager(play_state:Play) {
			this.play_state = play_state;
			init();
		}
		
		private function init():void {
			// do nothing
		}
		
		public function update():void {
			var i:int; var j:int;
			dens = play_state.getLevelManager().getDenizens();
			mins_skel = play_state.getLevelManager().getMinsSkel();
			mins_mino = play_state.getLevelManager().getMinsMino();
			lvl_bounds = play_state.getLevelManager().getLevelBounds();
			// collision checks for skeleton minions
			for (i = 0; i < mins_skel.length; i++) {
				// check for collisions with level bounds
				for (j = 0; j < lvl_bounds.length; j++) {
					if (CollisionDetection.rectCollide(lvl_bounds[j], mins_skel[i], play_state.getLevelManager())) {
						mins_skel[i].onBoundCollision(lvl_bounds[j]);
					}
				}
				// check for collisions with other skeletons
				for (j = 0; j < mins_skel.length; j++) {
					// if mins_skel[i] and mins_skel[j] are colliding
					if (CollisionDetection.radCollide(mins_skel[i], mins_skel[j], play_state.getLevelManager())) {
						// keep closer display objects on top
						if (mins_skel[i].y > mins_skel[j].y && play_state.getLevelManager().getChildIndex(mins_skel[i]) < play_state.getLevelManager().getChildIndex(mins_skel[j])) {
							play_state.getLevelManager().swapChildren(mins_skel[i], mins_skel[j]);
						}
					}
				}
				// check for collisions with minotaurs
				for (j = 0; j < mins_mino.length; j++) {
					// if mins_skel[i] and mins_mino[j] are colliding
					if (CollisionDetection.radCollide(mins_skel[i], mins_mino[j], play_state.getLevelManager())) {
						// keep closer display objects on top
						if (mins_skel[i].y > mins_mino[j].y && play_state.getLevelManager().getChildIndex(mins_skel[i]) < play_state.getLevelManager().getChildIndex(mins_mino[j])) {
							play_state.getLevelManager().swapChildren(mins_skel[i], mins_mino[j]);
						}
					}
				}
				// check for collisions with denizens
				for (j = 0; j < dens.length; j++) {
					// radial collision detection -> cheap
					if (CollisionDetection.radCollide(dens[j], mins_skel[i] , play_state.getLevelManager())) {
						// keep display objects in order
						if (mins_skel[i].y > dens[j].y && play_state.getLevelManager().getChildIndex(mins_skel[i]) < play_state.getLevelManager().getChildIndex(dens[j])) {
							play_state.getLevelManager().swapChildren(mins_skel[i], dens[j]);
						}
						// handle collision
						mins_skel[i].onDenizenCollision(dens[j]);
					}
				}
			}
			// collision checks for mionotaurs
			for (i = 0; i < mins_mino.length; i++) {
				// check for collisions with level bounds
				for (j = 0; j < lvl_bounds.length; j++) {
					if (CollisionDetection.rectCollide(lvl_bounds[j], mins_mino[i], play_state.getLevelManager())) {
						mins_mino[i].onBoundCollision(lvl_bounds[j]);
					}
				}
				// check for collisions with denizens
				for (j = 0; j < dens.length; j++) {
					// radial collision detection -> cheap
					if (CollisionDetection.radCollide(dens[j], mins_mino[i] , play_state.getLevelManager())) {
						// keep display objects in order
						if (mins_mino[i].y > dens[j].y && play_state.getLevelManager().getChildIndex(mins_mino[i]) < play_state.getLevelManager().getChildIndex(dens[j])) {
							play_state.getLevelManager().swapChildren(mins_mino[i], dens[j]);
						}
						// handle collision
						mins_mino[i].onDenizenCollision(dens[j]);
					}
				}
			}
		}
		
		// empty
		public function destroy():void {
			
		}
	}
}