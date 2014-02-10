package com.view.utils
{
	import com.model.Session;
	
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;

	public class SoundPlayer
	{
		private var _sounds:Vector.<Sound> = new Vector.<Sound>();
		
		public function SoundPlayer()
		{
		}
		
		public function getSound(prefix:String,soundStr:String):Sound{
			trace(prefix+Session.lang+soundStr)
			var sound:Sound = new Sound(new URLRequest(prefix+"/"+Session.lang+"/"+soundStr));
			return sound;
		}
		
		public function stopSounds():void{
			SoundMixer.stopAll();
		}
	}
}