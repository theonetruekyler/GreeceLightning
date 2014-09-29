package core {
	
	import flash.display.Bitmap;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Me
	 */
	public class Assets {
		
		// declare skeleton atlas (eventually minion atlas)
		[Embed(source="assets/texture_atlas.png")]
		private static var texture_atlas:Class;
		public static var text_at:TextureAtlas;
		[Embed(source="assets/texture_atlas.xml", mimeType="application/octet-stream")]
		private static var text_at_XML:Class;
		
		public static function init():void {	
			// initialize texture atlas
			text_at = new TextureAtlas(Texture.fromBitmap(new texture_atlas()), XML(new text_at_XML()));			
		}
		
		
		/****JUST ADDED, will change to atlas later****/
		// AS3 embedding	
		[Embed(source="assets/cloud.png")]
		private static const cloud:Class;
		
		[Embed(source="assets/book.png")]
		private static const book:Class;
		
		[Embed(source="assets/background.jpg")]
		private static const background:Class;
		
		// font
		[Embed(source="../core/assets/Basileus.TTF", fontName="Basileus", embedAsCFF="false", mimeType="application/x-font")]
		private var myEmbeddedFont:Class;
		
		// Greece map
		[Embed(source="assets/Greece.jpg")]
		private static const map:Class;
		
		// scroll
		[Embed(source="assets/scroll.png")]
		private static const scroll:Class;
		
		// scrollButton
		[Embed(source="assets/scrollButton.png")]
		private static const scrollButton:Class;
		
		// exitButton
		[Embed(source="assets/exit.png")]
		private static const exit:Class;
		
		// leftButton
		[Embed(source="assets/arrowleft.png")]
		private static const left:Class;
		
		// rightButton
		[Embed(source="assets/arrow.png")]
		private static const right:Class;
		
		// supernova
		[Embed(source="assets/supernova.png")]
		private static const supernova:Class;
		
		// dictionary array for all assets (for optimization)
		private static var gameTextures:Dictionary = new Dictionary();
		
		// returns texture when needing to create new Image or Button
		public static function getTexture(name:String):Texture
		{			
			if (gameTextures[name] == undefined)
			{	
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}	
	}
}