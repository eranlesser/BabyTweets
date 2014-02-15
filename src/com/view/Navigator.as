package com.view
{
	import com.model.Session;
	import com.model.rawData.Texts;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Navigator extends Sprite
	{
		
		
		[Embed(source="../../assets/confBut.png")]
		private var wBird : 			Class;
		private var _menuText:TextField;
		protected var _texts:Texts;
		public var gotoSignal:Signal = new Signal();
		public function Navigator()
		{
			init();
		}
		
		private function init():void{
			_texts = new Texts();
			addMenuBtn();
			Session.langChanged.add(onSessionLanguageChanged);
		}
		
		private function addMenuBtn():void{
			var whereBird:Button = new Button(Texture.fromBitmap(new wBird()));
			addChild(whereBird);
			whereBird.x=8;
			whereBird.y=8;
			whereBird.addEventListener(starling.events.Event.TRIGGERED,openMenu);
			_menuText = new TextField(whereBird.width,40,_texts.getText("menu"),"Verdana",_texts.getMenuTextSize(),0x002661);
			addChild(_menuText);
			_menuText.x=whereBird.x;
			_menuText.y=whereBird.y+whereBird.height-9;
		}
		
		private function onSessionLanguageChanged():void{
			_menuText.text = _texts.getText("menu");
			_menuText.fontSize = _texts.getMenuTextSize();
		}
		
		private function openMenu():void{
			gotoSignal.dispatch(-1);
		}
	}
}