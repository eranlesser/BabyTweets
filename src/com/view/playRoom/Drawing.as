package com.view.playRoom
{
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Drawing extends Image
	{
		[Embed(source="../../../assets/playroom/drawing.png")]
		private var drawing : Class;
		private var _sound:Sound;
		public function Drawing()
		{
			
			super(Texture.fromBitmap( new drawing() ));
			addEventListener(TouchEvent.TOUCH,onTouch);
			_sound = new Sound(new URLRequest("../../../assets/sounds/playroom/clink_sound.mp3"));
			var cnl:SoundChannel = _sound.play();
			cnl.stop();
		}
		private var _isDragging:Boolean=false;
		private function onTouch(t:TouchEvent):void{
			var touch:Touch = t.getTouch(stage);
			if(touch == null){
				return;
			}
			if((touch.phase == TouchPhase.BEGAN)){
				_isDragging = true;
			}
			if(touch.phase == TouchPhase.MOVED && _isDragging){
				this.x = touch.globalX - this.width/2;
				this.y = touch.globalY - this.height/2;
				this.scaleX=0.7;
				this.scaleY=0.7;
			}
			if(touch.phase == TouchPhase.ENDED){
				_isDragging = false;
				this.scaleX=1;
				this.scaleY=1;
				_sound.play();
			}
		}
		
		
		
		private function onMouseMove(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			this.x = e.stageX;
			this.y = e.stageY;
		}
	}
}