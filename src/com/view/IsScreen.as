package com.view
{
	import com.Dimentions;
	import com.model.Item;
	import com.model.ScreenModel;
	import com.view.components.ImageItem;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;

	public class IsScreen extends AbstractScreen implements IScreen
	{
		[Embed(source="../../assets/whereBird.png")]
		private var wBird : 			Class;
		[Embed(source="../../assets/whereBird_note.png")]
		private var wBirdNote : 			Class;
		private var _counter:			uint=0;
		private var _setItemsDelayer:	IAnimatable;
		protected var _whoIs:				Item;
		private var _goodFeedBack:String;
		protected var _model:				ScreenModel;
		private var _whereBird:Button;
		public function IsScreen(screenModel:ScreenModel)
		{
			_model = screenModel;
			super();
		}
		
		protected function  onDistractorTouch(imageItem:ImageItem):void{
			if(!isEnabled){
				return;
			}
			var sound:Sound;
			if(_model.distractorType == ""){
				sound = _soundManager.getSound("../assets/narration/",imageItem.aSound);
			}else{
				sound = _soundManager.getSound("../assets/narration/",_whoIs.qSound);
			}	
			var chnl:SoundChannel = sound.play();
			chnl.addEventListener(flash.events.Event.SOUND_COMPLETE,function onChnl():void{
				chnl.removeEventListener(flash.events.Event.SOUND_COMPLETE,onChnl);
				if(imageItem.enhanceSound!=""){
					var hSound:Sound = new Sound(new URLRequest("../assets/sounds/effects/"+imageItem.enhanceSound));
					hSound.play();
				}
				isEnabled=true;
			});
			isEnabled = false;
		}
		
		override public function set isEnabled(bool:Boolean):void{
			super.isEnabled = bool;
			var fltr:ColorMatrixFilter = new ColorMatrixFilter();
			//filter.invert();
			fltr.adjustSaturation(-0.7);
			if(bool == false){
				_screenLayer.filter=fltr;
			}else{
				_screenLayer.filter=null;
				//removeChild(_bg)
			}
			
		}
		
		override protected function init():void{
			super.init()
			if(_model.categorySound!=""){
				_categorySound = _soundManager.getSound("../assets/narration/",_model.folder +"/"+ _model.categorySound);
				var chnl:SoundChannel = _categorySound.play();
				_categorySoundPlaying=true;
				chnl.addEventListener(flash.events.Event.SOUND_COMPLETE,onCatSoundDone);
			}
			_counter=0;
			_whereBird = new Button(Texture.fromBitmap(new wBird()));
			addChild(_whereBird);
			_wBirdNote = new Button(Texture.fromBitmap(new wBirdNote()));
			addChild(_wBirdNote);
			_wBirdNote.visible = false;
			_whereBird.x = Dimentions.WIDTH - _whereBird.width//-2;
			_wBirdNote.x = Dimentions.WIDTH - _wBirdNote.width//-2;
			_whereBird.addEventListener(starling.events.Event.TRIGGERED,onWhereBird);
		}
		
		private function onWhereBird():void{
			if(isEnabled){
				playWhoIsSound();
			}
		}
		
		public function get model():ScreenModel{
			return _model;
		}
		
		
		
		
		protected function goodSoundComplete(e:flash.events.Event):void{
			_setItemsDelayer = Starling.juggler.delayCall(setItems,2);
			SoundChannel(e.target).removeEventListener(flash.events.Event.SOUND_COMPLETE, goodSoundComplete);
		}
		
		
		
		protected function playWhoIsSound():void{
			_wBirdNote.visible=true;
			var sound:Sound = _soundManager.getSound("../assets/narration/",_whoIs.qSound);
			var chanel:SoundChannel = sound.play(); 
			chanel.addEventListener(flash.events.Event.SOUND_COMPLETE,onWhereSoundDone);
			isEnabled=false;
		}
		private function get goodFeedBack():String{
			var soundFile:String;
			//soundFile = 192+Math.floor(Math.random()*19)+".mp3";
			soundFile = "/good/"+int(1+Math.floor(Math.random()*19.8))+".mp3";
			if(soundFile==_goodFeedBack){
				soundFile=goodFeedBack;
			}
			_goodFeedBack = soundFile;
			return soundFile;
		}
		private function get goodLastFeedBack():String{
			var soundFile:String;
			soundFile = "/good/"+int(20+Math.floor(Math.random()*6.8))+".mp3";
			if(soundFile==_goodFeedBack){
				soundFile=goodFeedBack;
			}
			_goodFeedBack = soundFile;
			return soundFile;
		}
		
		override protected function onCatSoundDone(e:flash.events.Event):void{
			super.onCatSoundDone(e);
			Starling.juggler.delayCall(playWhoIsSound,1);
		}
		
		protected function setItems():Boolean{
			_model.resetDistractors();
			isEnabled = false;
			if(_counter>=_model.numItems){
				complete();
				dispatchDone();
				return false;
			}
			_counter++;
			return true;
		}
		
		protected function onGoodClick():Boolean{ 
			if(!isEnabled){
				return false;
			}
			var goodSound:Sound;
			if(_counter>=_model.numItems){
				closeCurtains();
				goodSound = _soundManager.getSound("../assets/narration/",goodLastFeedBack);
			}else{
				goodSound = _soundManager.getSound("../assets/narration/",goodFeedBack);
			}
			var channel:SoundChannel = goodSound.play();
			channel.addEventListener(flash.events.Event.SOUND_COMPLETE,goodSoundComplete);
			_isEnabled=false;//don't blur
			//var fltr:ColorMatrixFilter = new ColorMatrixFilter();
			//filter.invert();
			//fltr.adjustSaturation(0.5);
			//_screenLayer.filter=fltr;
			return true;
		}
		
		protected function onWhereSoundDone(e:flash.events.Event):void{
			var chanel:SoundChannel= e.target as SoundChannel;
			isEnabled = true
			chanel.removeEventListener(flash.events.Event.SOUND_COMPLETE,onWhereSoundDone);
			_wBirdNote.visible=false;
		}
		
		override public function destroy():void{
			Starling.juggler.remove(_setItemsDelayer);
			_whereBird.removeEventListener(starling.events.Event.TRIGGERED,onWhereBird);
			removeEventListeners();
			var chld:DisplayObject;
			while(_screenLayer.numChildren>0){
				chld = _screenLayer.getChildAt(0);
				if(chld is ImageItem){
					(chld as ImageItem).touched.removeAll();
				}
				_screenLayer.removeChild(chld,true);
			}
			while(this.numChildren>0){
				chld = getChildAt(0);
				if(chld is ImageItem){
					(chld as ImageItem).touched.removeAll();
				}
				removeChild(chld,true);
			}
			//removeChildren();
			_model.reset();
			_soundManager.stopSounds();
		}
	}
}