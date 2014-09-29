package objects.tiles  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class Tileset extends Sprite {
		
		private var tilesetName:String;
		private var source:String;
		private var firstGid:int;
		private var lastGid:int;
		private var tileWidth:int;
		private var tileHeight:int;
		private var tileAmountWidth:int;
		private var imageWidth:int;
		private var imageHeight:int;
		private var bitmapData:BitmapData;
		
		public function Tileset(tilesetName:String, source:String, firstGid:int, tileWidth:int, tileHeight:int, imageWidth:int, imageHeight:int) {
			this.tilesetName = tilesetName;
			this.source = source;
			this.firstGid = firstGid;
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			this.imageWidth = imageWidth;
			this.imageHeight = imageHeight;
			tileAmountWidth = Math.round(imageWidth / tileWidth);
			lastGid = tileAmountWidth * Math.floor(imageHeight / tileHeight) + firstGid - 1;
		}
		
		public function getName():String {
			return name;
		}
		
		public function getSource():String {
			return source;
		}
		
		public function getFirstGid():int {
			return firstGid;
		}
		
		public function getLastGid():int {
			return lastGid;
		}
		
		public function getTileWidth():int {
			return tileWidth;
		}
		
		public function getTileHeight():int {
			return tileHeight;
		}
		
		public function getImageWidth():int {
			return imageWidth;
		}
		
		public function getImageHeight():int {
			return imageHeight;
		}
		
		public function getTileAmountWidth():int {
			return tileAmountWidth;
		}
		
		// returns tilesheet
		public function getBMD():BitmapData {
			return bitmapData;
		}
		
		// set tilesheet
		public function setBMD(bitmapData:BitmapData):void {
			this.bitmapData = bitmapData;
		}
	}

}