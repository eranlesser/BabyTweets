package com.view.menu
{
	
	import com.Dimentions;
	import com.model.ScreensModel;
	import com.model.Session;
	import com.model.rawData.Texts;
	import com.utils.Monotorizer;
	import com.view.components.ScreensMenu;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class ConfigurationScreen extends Sprite
	{
		[Embed(source="../../../assets/home/homeBtn.png")]
		private var homeBt : 			Class;
		
		[Embed(source="../../../assets/menu/bg.png")]
		private var bg : 			Class;
		[Embed(source="../../../assets/menu/screens.png")]
		private var screens : 			Class;
		
		[Embed(source="../../../assets/menu/about.png")]
		private var about : 			Class;
		
		public var goHome:Signal = new Signal();
		private var _navText:TextField;
		private var _aboutText:TextField;
		private var _displayLayer:Sprite;
		
		private var _menu:ScreensMenu;
		private var _texts:Texts;
		private var _about:About;
		public function ConfigurationScreen(screensModel:ScreensModel)
		{
			addChild(new Image(Texture.fromBitmap(new bg())));
			_menu = new ScreensMenu(screensModel);
			//_menu.y=110;
			init();
			addChild(_menu);
			
			
		}
		
		public function get menu():ScreensMenu{
			return _menu;
		}
		
		private function init():void{
			var homeBut:Button = new Button( Texture.fromBitmap(new homeBt()) );
			addChild(homeBut);
			homeBut.x=8;
			homeBut.y=8;
			homeBut.addEventListener(starling.events.Event.TRIGGERED, function():void{
				goHome.dispatch()
			});
			_texts = Texts.instance;;
			var navButton:Button = new Button( Texture.fromBitmap(new screens()) );
			var aboutButton:Button = new Button( Texture.fromBitmap(new about()));
			
			navButton.addEventListener(starling.events.Event.TRIGGERED,function():void{setState("nav")});
			aboutButton.addEventListener(starling.events.Event.TRIGGERED,function():void{setState("about")});
			aboutButton.x=Dimentions.WIDTH/2+20;
			navButton.x=Dimentions.WIDTH/2-navButton.width-20;
			navButton.y=8;
			aboutButton.y=8;
			_navText = new TextField(navButton.width,40,(_texts.getText("nav")),"Verdana",19,0x003B94);
			_navText.hAlign = "center";
			_navText.touchable=false;
			_navText.x = navButton.x;
			_navText.y=navButton.y + navButton.height - 42;
			_aboutText = new TextField(aboutButton.width,40,(_texts.getText("about")),"Verdana",19,0x002661);
			_aboutText.hAlign = "center";
			_aboutText.touchable = false;
			_aboutText.x = aboutButton.x;
			_aboutText.y=_navText.y;
			
			Session.langChanged.add(setTexts);
			if(Session.deviceId==2){
				addChild(navButton);
				addChild(aboutButton);
				addChild(_navText);
				addChild(_aboutText);
			}
			setState("nav");
		}
		
		
		private function setTexts():void{
			_aboutText.text = _texts.getText("about");
			_navText.text =  _texts.getText("nav");
		}
		
		private function setState(stt:String):void{
			Monotorizer.logEvent("configMenu",stt);
			_navText.color = 0x002661;
			_aboutText.color = 0x002661;
			if(stt=="nav"){
				_navText.color = 0x003B94;
				_menu.visible = true;
				if(_about){
					_about.visible=false;
				}
			}else{
				if(!_about){
					_about = new About();
					addChild(_about);
				}
				_aboutText.color=0x003B94;
				_about.visible=true;
				_menu.visible = false;
			
		}
		
		
	
	}
}
}
import com.model.Session;
import com.model.rawData.Texts;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.HAlign;
import starling.utils.VAlign;


class About extends Sprite{
	private var _aboutHeb:Sprite;
	private var _about:TextField;
	[Embed(source="../../../assets/about.png")]
	private var aboutPng : Class;
	public function About(){
		init();
	}
	
	private function init():void
	{
		// TODO Auto Generated method stub
		_aboutHeb = new Sprite();
		_aboutHeb.addChild(new Image(Texture.fromBitmap(new aboutPng())));
		_aboutHeb.y=110;
		addChild(_aboutHeb);
		_about = new TextField(700,600,Texts.instance.getAboutText(),"Verdana",18,0x2C3E50);
		addChild(_about);
		_about.y=140;
		_about.vAlign = VAlign.TOP;
		_about.hAlign = HAlign.LEFT;
		_about.x=185;
		_about.visible=false;
		_aboutHeb.visible=false;
		Session.langChanged.add(setLang);
		setLang();
	}
	
	private function setLang():void{
		if(Session.lang=="israel"){
			_aboutHeb.visible=true;
			_about.visible=false;
		}else{
			_about.text = Texts.instance.getAboutText();
			_aboutHeb.visible=false;
			_about.visible=true;
			
		}
	}
}


