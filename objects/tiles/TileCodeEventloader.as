package objects.tiles {
	import flash.display.Loader;
	
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class TileCodeEventloader extends Loader {
		
		private var tileset:Tileset;
		
		public function TileCodeEventloader() {
			
		}
		
		public function getTileset():Tileset {
			return tileset;
		}
		
		public function setTileset(tileset:Tileset):void {
			this.tileset = tileset;
		}
	}
}