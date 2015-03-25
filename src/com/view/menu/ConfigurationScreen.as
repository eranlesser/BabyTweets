package com.view.menu
{
	
	import com.model.ScreensModel;
	import com.model.rawData.Texts;
	import com.view.components.ScreensMenu;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class ConfigurationScreen extends Sprite
	{
		[Embed(source="../../../assets/home/homeBtn.png")]
		private var homeBt : 			Class;
		
		[Embed(source="../../../assets/menu/bg.png")]
		private var bg : 			Class;
		
		
		public var goHome:Signal = new Signal();
		private var _displayLayer:Sprite;
		
		private var _menu:ScreensMenu;
		private var _texts:Texts;
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
			//var navButton:Button = new Button( Texture.fromBitmap(new screens()) );
			//var aboutButton:Button = new Button( Texture.fromBitmap(new about()));
			
			
//			aboutButton.x=Dimentions.WIDTH/2+20;
//			navButton.x=Dimentions.WIDTH/2-navButton.width-20;
//			navButton.y=8;
//			aboutButton.y=8;
//			
//			
//			if(Session.deviceId==2){
//				addChild(navButton);
//				addChild(aboutButton);
//			}
		}
		
		
		
		
		
		
	
	}
}


