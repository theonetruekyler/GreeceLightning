package core {
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	import starling.utils.RectangleUtil;
	
	[SWF(width=800, height=480, framerate=30, backgroundColor=0x4F4F4F)]
	public class Main extends Sprite {	
		// where the magic happens
		public function Main() {
			// dimensions the game was deisnged on
			var stageWidth:int = 800;
			var stageHeight:int = 480;
			// scaled viewport
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight),
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
				StageScaleMode.SHOW_ALL
			);
			// initialize starling
			Starling.multitouchEnabled = true;
			var starling:Starling = new Starling(Game, stage, viewPort);
			starling.stage.stageWidth = stageWidth;
			starling.stage.stageHeight = stageHeight;
			// stats for debugging
			starling.showStats = true;
			// start
			starling.start();
		}
	}
}