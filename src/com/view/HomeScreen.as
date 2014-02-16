package com.view
{
	import com.Dimentions;
	import com.model.ScreensModel;
	import com.model.Session;
	import com.model.rawData.Texts;
	import com.utils.filters.GlowFilter;
	import com.view.components.FlagsMenu;
	
	import flash.text.TextFieldAutoSize;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class HomeScreen extends AbstractScreen
	{
		
		[Embed(source="../../assets/home/plybtn.png")]
		private var playBt : Class;
		[Embed(source="../../assets/home/home.png")]
		private var home : Class;
		
		//private var _clouds:Clouds;
		private var _flags:FlagsMenu;
		
		private var _titleText:TextField;
		private var _texts:Texts;
		public var ready:Signal = new Signal();
		public var goToSignal:Signal = new Signal();
		
		public function HomeScreen(screenModel:ScreensModel)
		{
//			var playText:TextField = new TextField(playBut.width,32,_texts.getText("play"),"Verdana",20,0x002661);
//			addChild(playText);
//			playText.filter = new GlowFilter(0xFFFFFF);
//			playText.hAlign = HAlign.CENTER;
//			playText.x=playBut.x+12;
//			playText.y=playBut.y+playBut.height-5;
			
			_texts = Texts.instance;
		}
		
		override protected function init():void{
			super.init();
			var homeBg:Image = new Image(Texture.fromBitmap(new home()))
			_screenLayer.addChild(homeBg);
			addTitleText(); // before init (language change dispached)
			_flags = new FlagsMenu(Session.lang);
			//_flags.visible=false;
			_flags.y=16;
			_flags.x=Dimentions.WIDTH-_flags.width-8;
			_screenLayer.addChild(_flags);
			var playBut:Button = new Button( Texture.fromBitmap(new playBt()) );
			addChild(playBut);
			playBut.x=110//(Dimentions.WIDTH-playBut.width)/3;
			playBut.y=168;
			playBut.addEventListener(Event.TRIGGERED,function():void{
				goToSignal.dispatch(Session.currentScreen)
			});
			this.addEventListener(TouchEvent.TOUCH,onTouch);
			ready.dispatch();
		}
		
		private function addTitleText():void{
			_titleText = new TextField(550,100,_texts.getText("title"),"Verdana",52,0x002661);
			addChild(_titleText);
			_titleText.autoSize =  TextFieldAutoSize.CENTER;
			_titleText.x=Dimentions.WIDTH-_titleText.width//+20;
			_titleText.y=318;
			_titleText.filter = new GlowFilter(0xFFFFFF);
			Session.langChanged.add(onSessionLanguageChanged);
		}
		
		private function onTouch(t:TouchEvent):void{
			if(t.getTouch(stage)&&(t.getTouch(stage).phase == TouchPhase.BEGAN)){
				if(t.getTouch(stage).target is Image && ((t.getTouch(stage).target as Image).width == 130||(t.getTouch(stage).target as Image).width == 200)){
					return;
				}
				_flags.close();
			}
		}
		
		private function onSessionLanguageChanged():void{
			_titleText.text = _texts.getText("title");
			_titleText.x = Dimentions.WIDTH-_titleText.width;
		}
		
		
	}
}

