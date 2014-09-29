package interfaces {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author kyler thompson
	 */
	public interface Minion {
		// basic update & destroy
		function update():void;
		function destroy():void;
		// how to react when touched
		function onTouch():void;
		// how to react to level bound collisions
		function onBoundCollision(bound:Rectangle):void;
		// return the minion's current destination
		function getDestination():Point;
		// redirect the minion
		function setDestination(pos:Point):void;
	}
}