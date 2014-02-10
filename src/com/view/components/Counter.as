package com.view.components
{
	import com.model.Session;
	import com.view.playRoom.Book;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;

	public class Counter
	{
		private var _to:uint;
		private var _index:uint = 0;
		private var _delayCall:DelayedCall;
		public var done:Signal = new Signal();
		public var tick:Signal = new Signal();
		public var isDone:Boolean = false;
		private var _soundStr:String = "../../../../assets/narration/"+Session.lang+"/counter/";
		public function Counter()
		{
		}
		
		public function count(to:uint,delay:uint=0):void{
			_index=0;	
			_to=to;
			if(delay>0){
				_delayCall = Starling.juggler.delayCall(progress,delay);
			}
		}
		
		public function progress():void{
			_index++;
			var coundSound:Sound = new Sound(new URLRequest(_soundStr+_index.toString()+".mp3"));
			var chnl:SoundChannel = coundSound.play();
			chnl.addEventListener(Event.SOUND_COMPLETE,function onSound():void{
				chnl.removeEventListener(Event.SOUND_COMPLETE,onSound);
				tick.dispatch();
			});
			if(_index==_to){
				done.dispatch();
				isDone = true;
			}
		}
		
	}
}