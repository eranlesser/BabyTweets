package com.view.components
{
	import com.model.Session;
	import com.sticksports.nativeExtensions.flurry.Flurry;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class FlagsMenu extends Sprite
	{
		[Embed(source="../../../assets/flags/flags.xml", mimeType="application/octet-stream")]
		private const flags_xml:Class;
		
		[Embed(source="../../../assets/flags/flags.png")]
		private  const flags:Class;
		[Embed(source="../../../assets/flags/combo.png")]
		private  const bg:Class;
		
		private var _atlas:TextureAtlas;
		private var _selectedFlag:Flag;
		private var _container:Sprite;
		public static const FLAG_WIDTH:uint = 80;
		
		public static var RUSSIA:String="russia";
		public static var USA	:String="usa";
		public static var ISRAEL:String="israel";
		public static var FRANCE:String="france";
		
		public function FlagsMenu(lang:String)
		{
			var texture:Texture=  Texture.fromBitmap(new flags());
			_atlas = new TextureAtlas(texture,new XML(new flags_xml()) as XML);
			var btn:Button = addChild(new Button(Texture.fromBitmap(new bg()))) as Button;
			btn.addEventListener(Event.TRIGGERED,onOpen);
			btn.x=-16;
			btn.y=-6;
			btn.alpha=0.6;
			addFlags();
			setSelectedFlag(lang)
		}
		
		public static function getLanguageFromLocale(lang:String):String{
			var str:String=ISRAEL;
			switch(lang){
				case "en":
					str=USA;
					break;
				case "fr":
					str=FRANCE;
					break;
				case "ru":
					str=RUSSIA;
					break;
				case "he":
					str=ISRAEL;
					break;
				
			}
			return str;
		}
		
		private function setSelectedFlag(lang:String):void{
			if(_selectedFlag){
				removeChild(_selectedFlag);
				_selectedFlag.clicked.remove(onOpen)
			}
			_selectedFlag = new Flag(_atlas.getTexture(lang),lang);
			addChild(_selectedFlag);
			_selectedFlag.width=80;
			_selectedFlag.height=60;
			_container.visible=false;
			Session.lang = lang;
			_selectedFlag.touchable = false;
			var hgt:uint=0;
			for(var i:uint=0;i<_container.numChildren;i++){
				var flag:Flag = _container.getChildAt(i) as Flag;
				if(flag.lang==lang){
					flag.y=0;
				}else{
					hgt=hgt+62;
					flag.y=hgt;
				}
			}
			
			Flurry.logEvent("language=",{language:lang});
		}
		
		private function onOpen(lang:String):void
		{
			_container.visible=!_container.visible;
			if(_selectedFlag){
				_selectedFlag.visible = !_selectedFlag.visible;
			}
			// TODO Auto Generated method stub
			
		}
		
		public function close():void{
			_container.visible=false;
			if(_selectedFlag){
				_selectedFlag.visible = true;
			}
		}
		
		private function addFlags():void{
			_container = new Sprite();
			addChild(_container);
			//_container.y=62;
			addFlag(ISRAEL);
			addFlag(RUSSIA);
			addFlag(USA);
			//addFlag("brazil");
			addFlag(FRANCE);
			//addFlag("holland");
		}
		private var _hgt:uint=0;
		private function addFlag(name:String):void{
			var flag:Flag = new Flag(_atlas.getTexture(name),name);
			_container.addChild(flag);
			flag.width=FLAG_WIDTH;
			flag.height=60;
			flag.y=_hgt;
			flag.clicked.add(setSelectedFlag);
			_hgt = _hgt+62;
		}
		
	}
}
import org.osflash.signals.Signal;

import starling.display.Button;
import starling.events.Event;
import starling.textures.Texture;

class Flag extends Button{
	private var _lang:String;
	public var clicked:Signal = new Signal();
	public function Flag(upstate:Texture,lang:String){
		_lang = lang;
		super(upstate);
		addEventListener(Event.TRIGGERED,onClicked);
	}
	
	private function onClicked(e:Event):void{
		clicked.dispatch(_lang)
	}
	
	public function get lang():String{
		return _lang;
	}
}