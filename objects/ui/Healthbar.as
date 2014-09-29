package objects.ui {
	import core.Assets;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class Healthbar extends Sprite {
		
		// Sprites
		private var hb_border:Image;
		private var hb_bar:Image;
		
		// etc.
		private var total:int;
		private var remainder:int;
		
		public function Healthbar(total:int) {
			// health variables
			this.total = total;
			remainder = total;
			
			
			// initialize textures
			hb_border = new Image(Assets.text_at.getTexture("healthbar/border"));
			addChild(hb_border);
			
			hb_bar = new Image(Assets.text_at.getTexture("healthbar/bar"));
			hb_bar.x = 1;
			addChild(hb_bar);
			
		}
		
		public function update(remainder:int):void {
			hb_bar.scaleX = (remainder / total);
		}
		
		public function destroy():void {
			this.removeChildren(0, 1, true);
			this.removeFromParent(true);
		}
	}
}