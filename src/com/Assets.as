package com
{	
	import flash.display.Bitmap;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		
		[Embed(source="../assets/toys1.xml", mimeType="application/octet-stream")]
		public static const toys1_xml:Class;
		
		[Embed(source="../assets/toys1.png")]
		public static const toys1:Class;
		
		[Embed(source="../assets/animals/atlas.xml", mimeType="application/octet-stream")]
		public static const animals_xml:Class;
		[Embed(source="../assets/animals/atlas.png")]
		public static const animals:Class;
		
		[Embed(source="../assets/clothes/atlas.xml", mimeType="application/octet-stream")]
		public static const clothes_xml:Class;
		[Embed(source="../assets/clothes/atlas.png")]
		public static const clothes:Class;
		[Embed(source="../assets/musicians/atlas.xml", mimeType="application/octet-stream")]
		public static const musicians_xml:Class;
		[Embed(source="../assets/musicians/atlas.png")]
		public static const musicians:Class;

		[Embed(source="../assets/fruitsAndVeg/atlas.xml", mimeType="application/octet-stream")]
		public static const fruitsAndVeg_xml:Class;
		[Embed(source="../assets/fruitsAndVeg/atlas.png")]
		public static const fruitsAndVeg:Class;

		[Embed(source="../assets/music/atlas.xml", mimeType="application/octet-stream")]
		public static const music_xml:Class;
		[Embed(source="../assets/music/atlas.png")]
		public static const music:Class;
		
		[Embed(source="../assets/playroom/atlas.xml", mimeType="application/octet-stream")]
		public static const playRoom_xml:Class;
		[Embed(source="../assets/playroom/atlas.png")]
		public static const playRoom:Class;

		[Embed(source="../assets/thumbnails/atlas.xml", mimeType="application/octet-stream")]
		public static const thumbNails_xml:Class;
		[Embed(source="../assets/thumbnails/atlas.png")]
		public static const thumbNails:Class;

		[Embed(source="../assets/egg/atlas.xml", mimeType="application/octet-stream")]
		public static const egg_xml:Class;
		[Embed(source="../assets/egg/atlas.png")]
		public static const egg:Class;
		
		[Embed(source = "../assets/lock.png")] 
		public static const Lock:Class;
		
		
		[Embed(source = "../assets/whereIsScene/animals2.png")] 
		private static const animals2:Class;
		[Embed(source = "../assets/whereIsScene/animals3.png")] 
		private static const animals3:Class;
		[Embed(source = "../assets/bodyparts/boyFull2.png")] 
		private static const boyFull2:Class;
		[Embed(source = "../assets/bodyparts/girlFace.png")] 
		private static const girlFace:Class;
		[Embed(source = "../assets/outdoors/outdoors.png")] 
		private static const outdoors1:Class;
		[Embed(source = "../assets/outdoors/outdoors2.png")] 
		private static const outdoors2:Class;
		[Embed(source = "../assets/whereIsScene/bathroom.png")] 
		private static const bathroom:Class;
		
		[Embed(source = "../assets/transportation/transportation.png")] 
		private static const transportation:Class;
		
		
		private static var _toysAtlas:TextureAtlas;
		private static var _animalsAtlas:TextureAtlas;
		private static var _playRoomAtlas:TextureAtlas;
		private static var _bodyPartsAtlas:TextureAtlas;
		private static var _musiciansAtlas:TextureAtlas;
		private static var _clothesAtlas:TextureAtlas;
		private static var _fruitsAndVeg:TextureAtlas;
		private static var _musicAtlas:TextureAtlas;
		private static var _eggAtlas:TextureAtlas;
		private static var _thumbsAtlas:TextureAtlas;
		private static var _assets:Vector.<Asset>;
		public static function getAtlas(groupName:String):TextureAtlas{
			var atlas:TextureAtlas;
			var texture:Texture;
			switch(groupName){
				case "toys1":
					if(_toysAtlas == null){
						texture=  Texture.fromBitmap(new Assets.toys1());
						_toysAtlas = new TextureAtlas(texture,new XML(new Assets.toys1_xml()) as XML);
					}
					atlas = _toysAtlas;
					break;
				case "animals":
					if(_animalsAtlas == null){
						texture =  Texture.fromBitmap(new Assets.animals());
						_animalsAtlas = new TextureAtlas(texture,new XML(new Assets.animals_xml()) as XML);
					}
					atlas = _animalsAtlas;
					break;
				case "playRoom":
					if(_playRoomAtlas == null){
						texture =  Texture.fromBitmap(new Assets.playRoom());
						_playRoomAtlas = new TextureAtlas(texture,new XML(new Assets.playRoom_xml()) as XML);
					}
					atlas = _playRoomAtlas;
					break;
				case "clothes":
					if(_clothesAtlas == null){
						texture =  Texture.fromBitmap(new clothes());
						_clothesAtlas = new TextureAtlas(texture,new XML(new clothes_xml()) as XML);
					}
					atlas = _clothesAtlas;
					break;
				case "fruitsAndVeg":
					if(_fruitsAndVeg == null){
						texture =  Texture.fromBitmap(new fruitsAndVeg());
						_fruitsAndVeg = new TextureAtlas(texture,new XML(new fruitsAndVeg_xml()) as XML);
					}
					atlas = _fruitsAndVeg;
					break;
				case "musicians":
					if(_musiciansAtlas == null){
						texture =  Texture.fromBitmap(new musicians());
						_musiciansAtlas = new TextureAtlas(texture,new XML(new musicians_xml()) as XML);
					}
					atlas = _musiciansAtlas;
					break;
				case "egg":
					if(_eggAtlas == null){
						texture =  Texture.fromBitmap(new egg());
						_eggAtlas = new TextureAtlas(texture,new XML(new egg_xml()) as XML);
					}
					atlas = _eggAtlas;
					break;
				case "thumbs":
					if(_thumbsAtlas == null){
						texture =  Texture.fromBitmap(new thumbNails());
						_thumbsAtlas = new TextureAtlas(texture,new XML(new thumbNails_xml()) as XML);
					}
					atlas = _thumbsAtlas;
					break;
			}
			
			return atlas;
		}
		
		public static function getImage(name:String):Bitmap{
			var btmp:Bitmap;
			for each(var asset:Asset in _assets){
				if(asset.name == name){
					btmp = asset.bitMap;
					break;
				}
			}
			return btmp;
		}
		
		public static function load():void{
			_assets = new Vector.<Asset>()
			_assets.push(new Asset("animals2",new animals2()));
			_assets.push(new Asset("animals3",new animals3()));
			_assets.push(new Asset("boyFull2",new boyFull2()));
			_assets.push(new Asset("girlFace",new girlFace()));
			_assets.push(new Asset("outdoors1",new outdoors1()));
			_assets.push(new Asset("outdoors2",new outdoors2()));
			_assets.push(new Asset("bathroom",new bathroom()));
			_assets.push(new Asset("transportation",new transportation()));
			
			
		}
		
		public function Assets()
		{
			
		}
	}
}
import flash.display.Bitmap;


class Asset{
	public var name:String;
	public var bitMap:Bitmap;
	public function Asset(nme:String,btmp:Bitmap){
		name = nme;
		bitMap = btmp;
	}
}