package libraries 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.display.MovieClip;
	
	public class CollisionDetection {
		
		// bounding box collision detection
		public static function boxCollide(target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer):Boolean {
			// get bounding boxes
			var rect1:Rectangle = target1.getBounds(commonParent);
			var rect2:Rectangle = target2.getBounds(commonParent);
			
			// check for intersection
			return rect1.intersects(rect2);
		}
		
		// rectangular bounds collision detection
		public static function rectCollide(rect1:Rectangle, target:DisplayObject, targetSpace:DisplayObjectContainer):Boolean {
			// get bounding box for target
			var rect2:Rectangle = target.getBounds(targetSpace);
			
			// check for intersection
			return rect1.intersects(rect2);
		}
		
		// radial collision detection
		// passing an offset creates a proximity check
		public static function radCollide(target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, offset:Number = 0.0):Boolean {
			// get bounding boxes
			var rect1:Rectangle = target1.getBounds(commonParent);
			var rect2:Rectangle = target2.getBounds(commonParent);
			
			// get centers of bounding boxes
			var center1:Point = new Point((rect1.left + rect1.right) * 0.5, (rect1.top + rect1.bottom) * 0.5);
			var center2:Point = new Point((rect2.left + rect2.right) * 0.5, (rect2.top + rect2.bottom) * 0.5);
			
			// check for collision
			if (Point.distance(center1, center2) < rect1.width * 0.5 + rect2.width * 0.5 + offset) {
				return true;
			} else {
				return false;
			}
		}
		
		public static function rectGlobalToLocal(rect:Rectangle, targetSpace:DisplayObjectContainer):Rectangle {
			var newTopLeft:Point = targetSpace.globalToLocal(rect.topLeft);
			var newBotRite:Point = targetSpace.globalToLocal(rect.bottomRight);
			var locRect:Rectangle = new Rectangle(newTopLeft.x, newTopLeft.y, newBotRite.x - newTopLeft.x, newBotRite.y - newTopLeft.y);
			return locRect;
		}
	}
}