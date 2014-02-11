package com.view
{
	import com.Dimentions;
	import com.view.components.ParticlesEffect;
	import com.view.utils.SoundPlayer;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
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
		private var _goHome:			Signal = new Signal();
		
		
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
			_screenLayer = new Sprite();
			addChild(_screenLayer);
			_guiLayer = new Sprite();
			addChild(_guiLayer);
		}
		
		protected function addHomeBtn():void{
			var homeBut:Button = new Button( Texture.fromBitmap(new homeBt()) );
			_guiLayer.addChild(homeBut);
			homeBut.x=8;
			homeBut.y=8;
			homeBut.addEventListener(starling.events.Event.TRIGGERED, function():void{
				complete();
				goHome.dispatch()
			});
		}
		
		public function get done():Signal
		{
			return _done;
		}

		public function get goHome():Signal
		{
			return _goHome;
		}
		
		public function get screenLayer():Sprite{
			return _screenLayer;
		}
		public function destroy():void{
			
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
		
		private function drawDarkBg():Image{
			var shp:Shape = new Shape();
			shp.graphics.beginFill(0x333333);
			shp.graphics.drawRect(0,0,Dimentions.WIDTH,Dimentions.HEIGHT);
			shp.graphics.endFill();
			var bmp:BitmapData = new BitmapData(Dimentions.WIDTH,Dimentions.HEIGHT,false,0x333333);
			bmp.draw(shp)
			var txture:Texture = Texture.fromBitmapData(bmp);
			var img:Image = new Image(txture);
			img.alpha=0.2;
			return img;
			//_screenLayer.addChild(img);
		}
		
		
		
	}
}