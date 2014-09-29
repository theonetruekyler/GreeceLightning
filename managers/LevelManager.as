package managers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import interfaces.Minion;
	import objects.denizens.Denizen;
	import objects.minions.Minotaur;
	import objects.minions.Pit;
	import objects.minions.Skeleton;
	import objects.tiles.TileCodeEventloader;
	import objects.tiles.Tileset;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import states.Play;
	import flash.xml.*;
	/**
	 * ...
	 * @author kyler thompson
	 */
	public class LevelManager extends Sprite {
		private var play_state:Play;
		
		// xml and xml loader
		private var xmlLoader:URLLoader;
		private var eventLoaders:Array;
		private var xml:XML;
		
		// map attributes
		private var mapWidth:int;		// units tiles
		private var mapHeight:int;		// units tiles
		private var tileWidth:int;		// units pixels
		private var tileHeight:int;		// units pixels
		private var tilesets:Array;
		private var totalTileSets:int;
		private var tilesetsLoaded:int;
		
		// bitmaps of level layers
		private var layer1:Image;
		private var layer2:Image;
		private var layer3:Image;
		private var screenBM_1:Bitmap;
		private var screenBM_2:Bitmap;
		private var screenBM_3:Bitmap;
		
		// object vectors
		private var levelBounds:Vector.<Rectangle>;
		private var denizens:Vector.<Denizen>;
		private var mins_skel:Vector.<Skeleton>;
		private var mins_mino:Vector.<Minotaur>;
		private var mins_pit:Vector.<Pit>;
		
		public function LevelManager(play_state:Play) {
			this.play_state = play_state;
			// add event listener
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// initializations
		private function init():void {
			// remove event listener
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			// init arrays
			levelBounds = new Vector.<Rectangle>;
			denizens = new Vector.<Denizen>;
			mins_skel = new Vector.<Skeleton>;
			mins_mino = new Vector.<Minotaur>;
			mins_pit = new Vector.<Pit>;
			// init xmlLoader
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);
			xml = new XML();
			// init tileset vars
			eventLoaders = new Array();
			tilesets = new Array();
			tilesetsLoaded = 0;
		}
		
// **************************************************************************************************************************
// ** LEVEL_CONSTRUCTION_FUNCTIONS                                                                                         **
// **************************************************************************************************************************
		
		// load xml file from path
		public function mapLoad(xmlPath:String):void {
			xmlLoader.load(new URLRequest(xmlPath));
		}
		
		// handler for xml loaded event
		private function xmlLoadComplete(event:flash.events.Event):void {
			xml = new XML(event.target.data);
			mapWidth = xml.attribute("width");			// tiles
			mapHeight = xml.attribute("height");		// tiles
			tileWidth = xml.attribute("tilewidth");		// pixels
			tileHeight = xml.attribute("tileheight");	// pixels
			var xmlCounter:int = 0;
			
			// for each tilesheet...
			for each (var tileset:XML in xml.tileset) {
				// make a tileset
				var firstGid:int = xml.tileset.attribute("firstgid")[xmlCounter];
				var tilesetName:String = xml.tileset.attribute("name")[xmlCounter];
				var tilesetTileWidth:int = xml.tileset.attribute("tilewidth")[xmlCounter];
				var tilesetTileHeight:int = xml.tileset.attribute("tileheight")[xmlCounter];
				var tilesetImagePath:String = xml.tileset.image.attribute("source")[xmlCounter];
				var imageWidth:uint = xml.tileset.image.attribute("width")[xmlCounter];
				var imageHeight:uint = xml.tileset.image.attribute("height")[xmlCounter];
				tilesets.push(new Tileset(tilesetName, tilesetImagePath, firstGid, tilesetTileWidth, tilesetTileHeight, imageWidth, imageHeight));
				xmlCounter++;
			}
			totalTileSets = xmlCounter;
			// load tilesheets
			for (var i:int = 0; i < totalTileSets; i++) {
				var loader:TileCodeEventloader = new TileCodeEventloader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, tilesLoadComplete);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.setTileset(tilesets[i]);
				loader.load(new URLRequest("maps/" + tilesets[i].getSource()));
				eventLoaders.push(loader);
			}
			// init BitmapData with appropriate size
			screenBM_1 = new Bitmap(new BitmapData(mapWidth * tileWidth, mapHeight * tileHeight, false, 0x0F0F0F));
			screenBM_2 = new Bitmap(new BitmapData(mapWidth * tileWidth, mapHeight * tileHeight, true, 0x0F0F0F));
			screenBM_3 = new Bitmap(new BitmapData(mapWidth * tileWidth, mapHeight * tileHeight, true, 0x0F0F0F));
		}
		
		// handler for tilesheet loaded event
		private function tilesLoadComplete(event:flash.events.Event):void {
			event.target.loader.getTileset().setBMD(Bitmap(event.target.content).bitmapData);
			tilesetsLoaded++;
			// if all tilesheets have been loaded...
			if (tilesetsLoaded == totalTileSets) {
				// add them to the display list
				addTileBitmapData();
			}
		}
		
		private function addTileBitmapData():void {
			// for each layer ...
			for each (var layer:XML in xml.layer) {
				var tiles:Array = new Array();
				var tileLength:int = 0;
				for each (var tile:XML in layer.data.tile) {
					var gid:Number = tile.attribute("gid");
					if (gid > 0) {
						tiles[tileLength] = gid;
					}
					tileLength++;
				}
				
				var useBitmap:BitmapData;
				var layerName:String = layer.attribute("name")[0];
				
				// set layerMap to appropriate value
				var layerMap:int = 1;
				switch(layerName) {
					case "Tile Layer 2":
						layerMap = 2;
						break;
					case "Tile Layer 3":
						layerMap = 3;
						break;
					default:
						// layerMap = 1;
				}
				var tileCoordinates:Array = new Array();
				for (var tileX:int = 0; tileX < mapWidth; tileX++) {
					tileCoordinates[tileX] = new Array();
					for (var tileY:int = 0; tileY < mapHeight; tileY++) {
						tileCoordinates[tileX][tileY] = tiles[tileX + (tileY * mapWidth)];
						// tileCoordinates now contains each tile's gid at the appropriate point.
					}
				}
				// calculate coordinates, add tile to layer bitmap
				for (var spriteForX:int = 0; spriteForX < mapWidth; spriteForX++) {
					for (var spriteForY:int = 0; spriteForY < mapHeight; spriteForY++) {
						// gid of texture in the tilesheet
						var tileGid:int = int(tileCoordinates[spriteForX][spriteForY]);
						var currentTileset:Tileset;
						for each(var tileset1:Tileset in tilesets) {
							if (tileGid >= tileset1.getFirstGid()-1 && tileGid <= tileset1.getLastGid()) {
								currentTileset = tileset1;
								break;
							}
						}
						// where the tile appears on screen
						var destY:int = spriteForY * tileHeight;
						var destX:int = spriteForX * tileWidth;
						// math that i don't really understand
						tileGid -= currentTileset.getFirstGid() - 1;
						// where the tile is on the sprite sheet
						var sourceY:int = Math.ceil(tileGid / currentTileset.getTileAmountWidth()) - 1;
						var sourceX:int = tileGid - (currentTileset.getTileAmountWidth() * sourceY) - 1;
						// copy the tile from the tileset onto our bitmap
						if(layerMap == 1) {
							screenBM_1.bitmapData.copyPixels(currentTileset.getBMD(), new Rectangle(sourceX * currentTileset.getTileWidth(), sourceY * currentTileset.getTileHeight(), currentTileset.getTileWidth(), currentTileset.getTileHeight()), new Point(destX, destY), null, null, true);
						}
						else if (layerMap == 2) {
							screenBM_2.bitmapData.copyPixels(currentTileset.getBMD(), new Rectangle(sourceX * currentTileset.getTileWidth(), sourceY * currentTileset.getTileHeight(), currentTileset.getTileWidth(), currentTileset.getTileHeight()), new Point(destX, destY), null, null, true);
						}
						else if (layerMap == 3) {
							screenBM_3.bitmapData.copyPixels(currentTileset.getBMD(), new Rectangle(sourceX * currentTileset.getTileWidth(), sourceY * currentTileset.getTileHeight(), currentTileset.getTileWidth(), currentTileset.getTileHeight()), new Point(destX, destY), null, null, true);
						}
					}
				}
			}
			// add objects
			for each (var objectgroup:XML in xml.objectgroup) {
				var objectGroup:String = objectgroup.attribute("name");
				switch(objectGroup) {
					case "levelBounds":
						for each (var object:XML in objectgroup.object) {
							levelBounds.push(new Rectangle(object.attribute("x"), object.attribute("y"), object.attribute("width"), object.attribute("height")));
						}
						break;
					case "minions":
						for each (var object1:XML in objectgroup.object) {
							if (object1.attribute("type") == "skeleton") {
								var skel:Skeleton = new Skeleton(play_state);
								skel.x = object1.attribute("x");
								skel.y = object1.attribute("y");
								mins_skel.push(skel);
							}
							else if (object1.attribute("type") == "minotaur") {
								var mino:Minotaur = new Minotaur(play_state);
								mino.x = object1.attribute("x");
								mino.y = object1.attribute("y");
								mins_mino.push(mino);
							}
							else if (object1.attribute("type") == "pit") {
								var pit:Pit = new Pit(play_state);
								pit.x = object1.attribute("x");
								pit.y = object1.attribute("y");
								mins_pit.push(pit);
							}
						}
						break;
					case "denizens":
						for each (var object2:XML in objectgroup.object) {
							if (object2.attribute("type") == "denizen") {
								var denz:Denizen = new Denizen(play_state);
								denz.x = object2.attribute("x");
								denz.y = object2.attribute("y");
								denizens.push(denz);
							}
						}
						break;
						
					default:
						// do nothing
						break;
				}
			}
			// add environmental layers
			addChild(layer1 = new Image(Texture.fromBitmap(screenBM_1)));
			addChild(layer2 = new Image(Texture.fromBitmap(screenBM_2)));
			addChild(layer3 = new Image(Texture.fromBitmap(screenBM_3)));
			for each (var denizen:Denizen in denizens) {
				addChild(denizen);
			}
			for each (var skel:Skeleton in mins_skel) {
				addChild(skel);
			}
			for each (var mino:Minotaur in mins_mino) {
				addChild(mino);
			}
			for each (var pit:Pit in mins_pit) {
				addChild(pit);
			}
		}
		
// **************************************************************************************************************************
// ** PROGRESS_BAR_IMPLEMETATION                                                                                          **
// **************************************************************************************************************************

		// implement loading bar
		private function progressHandler(event:Object):void {
			
		}
		
// **************************************************************************************************************************
// ** GET_SET_FUNCTIONS                                                                                                    **
// **************************************************************************************************************************
		
		// returns map width in pixels
		public function getMapWidth():Number {
			return mapWidth * tileWidth;
		}
		
		// returns map height in pixels
		public function getMapHeight():Number {
			return mapHeight * tileHeight;
		}
		
		public function getLevelBounds():Vector.<Rectangle> {
			return levelBounds;
		}
		
		public function getDenizens():Vector.<Denizen> {
			return denizens;
		}
		
		public function getMinsSkel():Vector.<Skeleton> {
			return mins_skel;
		}
		
		public function getMinsMino():Vector.<Minotaur> {
			return mins_mino;
		}
		
		public function getMinsPit():Vector.<Pit> {
			return mins_pit;
		}
		
		public function minionsDead():Boolean {
			if (mins_skel.length == 0 && mins_mino.length == 0 && mins_pit.length == 0) {
				return true;
			}
			return false;
		}
		
		public function denizensDead():Boolean {
			if (denizens.length == 0) {
				return true;
			}
			return false;
		}
		
// **************************************************************************************************************************
// ** LEVEL_MAINTENANCE_FUNCTIONS                                                                                          **
// **************************************************************************************************************************
		
		// update each unit
		public function update():void {
			var i:int;
			/* currently, denizens do nothing
			for (i = 0; i < denizens.length; i++) {
				denizens[i].update();
			}
			*/
			for (i = 0; i < mins_skel.length; i++) {
				mins_skel[i].update();
			}
			for (i = 0; i < mins_mino.length; i++) {
				mins_mino[i].update();
			}
			for (i = 0; i < mins_pit.length; i++) {
				mins_pit[i].update();
			}
		}
		
		// un-tested
		public function clear():void {
			var i:int;
			// clear denizens vector
			for each (var denizen:Denizen in denizens) { denizen.destroy(); }
			denizens.splice(0, denizens.length);
			// clear skeletons vector
			for each (var skel:Skeleton in mins_skel) { skel.destroy(); }
			mins_skel.splice(0, mins_skel.length);
			// clear minotaurs vector
			for each (var mino:Minotaur in mins_mino) { mino.destroy(); }
			mins_mino.splice(0, mins_mino.length);
			// clear pits vector
			for each (var pit:Pit in mins_pit) { pit.destroy(); }
			mins_pit.splice(0, mins_pit.length);
			// clear bounds vector
			levelBounds.splice(0, levelBounds.length);
			// remove and destroy each environmental layer
			this.removeChild(layer1, true);
			layer1 = null;
			this.removeChild(layer2, true);
			layer2 = null;
			this.removeChild(layer3, true);
			layer3 = null;
		}
		
		public function destroy():void {
			// remove and destroy children
			this.clear();
			// remove and destroy self
			this.removeFromParent(true);
		}
	}
}