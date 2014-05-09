package com.view
{
	import com.Dimentions;
	import com.model.ScreenModel;
	import com.model.rawData.Texts;
	import com.view.components.ParticlesEffect;
	import com.view.utils.SoundPlayer;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class AbstractScreen extends Sprite
	{
		
		protected var _categorySound:		Sound;
		//protected var _particlesEffect:		ParticlesEffect;
		protected var _categorySoundPlaying:Boolean=false;
		protected var _guiLayer:			Sprite;
		protected var _screenLayer:			Sprite;
		protected var _soundManager:		SoundPlayer = new SoundPlayer();
		protected var _isEnabled:			Boolean;		
		private var _done:					Signal = new Signal();
		protected var _model:				ScreenModel;
		public function AbstractScreen(model:ScreenModel)
		{
			_model = model
			addEventListener(starling.events.Event.ADDED_TO_STAGE,onAdded);
		}
		
		private function onAdded(e:starling.events.Event):void{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAdded);
			init();
		}
		
		protected function init():void
		{
			// TODO Auto Generated method stub
			_screenLayer = new Sprite();
			addChild(_screenLayer);
			_guiLayer = new Sprite();
			addChild(_guiLayer);
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
//			_particlesEffect = new ParticlesEffect();
//			_particlesEffect.y = Dimentions.HEIGHT/2;
//			_particlesEffect.x=(Dimentions.WIDTH-_particlesEffect.width)/2;
//			_screenLayer.addChild(_particlesEffect);
//			_particlesEffect.start("drug");
			trace("closeCurtains");
			
		}
		
		
		protected function dispatchDone():void{
			done.dispatch();
//			if(_particlesEffect){
//				_particlesEffect.stop();
//				//removeChild(_particlesEffect);
//			}
		}
		
		
		
		public function set isEnabled(bool:Boolean):void{
			
			_isEnabled=bool;
		}
		
		public function get isEnabled():Boolean{
			return _isEnabled;
		}
		
		protected function complete():void{
			
		}
		
		
		
	}
}