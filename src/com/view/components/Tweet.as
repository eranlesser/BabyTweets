package com.view.components
{
	import com.view.playRoom.Book;
	
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Tweet extends Sprite
	{
		[Embed(source="../../../assets/tweets/birds0.png")]
		private var birds : Class;
		[Embed(source="../../../assets/tweets/birds1.png")]
		private var birds1 : Class;
		[Embed(source="../../../assets/tweets/birds2.png")]
		private var birds2 : Class;
		[Embed(source="../../../assets/tweets/birds3.png")]
		private var birds3 : Class;
		[Embed(source="../../../assets/tweets/birds4.png")]
		private var birds4 : Class;
		private var _lastNoteImage:Image;
		private var _birdNotes:Vector.<Image> = new Vector.<Image>();
		private var _tweets:Vector.<Sound> = new Vector.<Sound>();
		public var clicked:Signal = new Signal();
		public function Tweet(bg:String,tweets:XML)
		{
			addChild(new Image(Texture.fromBitmap(new birds())));
			addEventListener(TouchEvent.TOUCH,onTouch);
			_birdNotes.push(new Image(Texture.fromBitmap(new birds1())));
			_birdNotes.push(new Image(Texture.fromBitmap(new birds2())));
			_birdNotes.push(new Image(Texture.fromBitmap(new birds3())));
			_birdNotes.push(new Image(Texture.fromBitmap(new birds4())));
			_tweets.push(new Sound(new URLRequest("../../assets/sounds/heb/birds2.mp3")))
			_tweets.push(new Sound(new URLRequest("../../assets/sounds/heb/birds3.mp3")))
			_tweets.push(new Sound(new URLRequest("../../assets/sounds/heb/birds4.mp3")))
			_tweets.push(new Sound(new URLRequest("../../assets/sounds/heb/birds5.mp3")))
		}
		
		public function play(tweet:Boolean=true):void{
			var call:DelayedCall = Starling.juggler.delayCall(addNote,0.2);
			call.repeatCount=12;
			Starling.juggler.delayCall(removeNote,0.2*13);
			if(tweet){
				var sound:Sound = new Sound(new URLRequest("../../assets/sounds/heb/birds1.mp3"))
				sound.play();
			}
		}
		
		public function tweet(playSound:Boolean):void{
			addNote();
			Starling.juggler.delayCall(removeNote,2);
			if(playSound){
				var rand:Number = Math.random();
				var sound:Sound;
				if(rand<0.2){
					sound = _tweets[0];
				}else if(rand<0.4){
					sound = _tweets[1];
				}else if(rand<0.6){
					sound = _tweets[2];
				}else{
					sound = _tweets[3];
				}
				sound.play();
			}
		}
		private function removeNote():void{
			if(numChildren>1){
				removeChildAt(1);
			}
		}
		
		private function addNote():void{
			removeNote();
			addChild(getRandomImage());
		}
		
		private function getRandomImage():Image{
			var rand:Number = Math.random();
			var img:Image;
			if(rand<0.25){
				img=_birdNotes[0];
			}else if(rand<0.5){
				img=_birdNotes[1];
			}else if(rand<0.75){
				img=_birdNotes[2];
			}else{
				img=_birdNotes[3];
			}
			if(_lastNoteImage==img){
				return getRandomImage();				
			}
			img.scaleX=-1;
			img.x=img.width;
			_lastNoteImage = img;
			return img;
		}
		
		private function onTouch(t:TouchEvent):void{
			if(t.getTouch(stage)&&(t.getTouch(stage).phase == TouchPhase.BEGAN)){
				clicked.dispatch();
			}
		}
	}
}
