package com.view
{
	import com.Dimentions;
	import com.model.Session;
	import com.model.rawData.Texts;
	import com.view.components.ParticlesEffect;
	import com.view.utils.SoundPlayer;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class AbstractScreen extends Sprite
	{
		
		protected var _categorySound:		Sound;
		protected var _particlesEffect:		ParticlesEffect;
		protected var _categorySoundPlaying:Boolean=false;
		protected var _guiLayer:			Sprite;
		protected var _screenLayer:			Sprite;
		protected var _soundManager:		SoundPlayer = new SoundPlayer();
		private var _isEnabled:				Boolean;		
		protected var _wBirdNote:			Button;
		[Embed(source="../../assets/home/homeBtn.png")]
		private var homeBt : 			Class;
		[Embed(source="../../assets/confBut.png")]
		private var wBird : 			Class;
		private var _menuText:TextField;
		protected var _texts:Texts;
		public var gotoSignal:Signal = new Signal();
		private var _done:Signal = new Signal();
		public function AbstractScreen()
		{
			addEventListener(starling.events.Event.ADDED_TO_STAGE,onAdded);
		}
		
		private function onAdded(e:starling.events.Event):void{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAdded);
			init();
		}
		
		protected function init():void
		{
			// TODO Auto Generated method stub
			_texts = new Texts();
			_screenLayer = new Sprite();
			addChild(_screenLayer);
			_guiLayer = new Sprite();
			addChild(_guiLayer);
		}
		
		
		public function onSessionLanguageChanged():void{
			_menuText.text = _texts.getText("menu");
			_menuText.fontSize = _texts.getMenuTextSize();
		}
		
		
		protected function addMenuBtn():void{
			var whereBird:Button = new Button(Texture.fromBitmap(new wBird()));
			_screenLayer.addChild(whereBird);
			whereBird.x=8;
			whereBird.y=8;
			whereBird.addEventListener(starling.events.Event.TRIGGERED,openMenu);
			_menuText = new TextField(whereBird.width,40,_texts.getText("menu"),"Verdana",_texts.getMenuTextSize(),0x002661);
			addChild(_menuText);
			_menuText.x=whereBird.x;
			_menuText.y=whereBird.y+whereBird.height-9;
		}
		
		public function get done():Signal
		{
			return _done;
		}

		
		public function get screenLayer():Sprite{
			return _screenLayer;
		}
		public function destroy():void{
			//Session.langChanged.remove(onSessionLanguageChanged);
		}
		
		protected function onCatSoundDone(e:flash.events.Event):void{
			var chnl:SoundChannel = e.target as SoundChannel;
			chnl.removeEventListener(flash.events.Event.SOUND_COMPLETE,onCatSoundDone);
			_categorySoundPlaying=false;
		}
		
		protected function closeCurtains():void{
			_particlesEffect = new ParticlesEffect();
			_particlesEffect.y = Dimentions.HEIGHT/2;
			_particlesEffect.x=(Dimentions.WIDTH-_particlesEffect.width)/2;
			_screenLayer.addChild(_particlesEffect);
			_particlesEffect.start("drug");
			
		}
		
		
		protected function dispatchDone():void{
			done.dispatch();
			if(_particlesEffect){
				_particlesEffect.stop();
				//removeChild(_particlesEffect);
			}
		}
		
		public function set isEnabled(bool:Boolean):void{
			
			_isEnabled=bool;
		}
		
		public function get isEnabled():Boolean{
			return _isEnabled;
		}
		
		protected function complete():void{
			
		}
		
		
		private function openMenu():void{
			gotoSignal.dispatch(-1);
		}
		
		
	}
}