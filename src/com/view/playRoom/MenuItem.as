package com.view.playRoom{
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class MenuItem extends Image{
		private var _isDragging:Boolean = false;
		private var _id:String;
		private var _recycled:Boolean;
		private var _registeredPoint:Point;
		public var dropped:Signal = new Signal();
		public function MenuItem(texture:Texture,id:String,isRecycled:Boolean)
		{
			super(texture);
			_id = id;
			if(this.width>(Menu.HEIGHT-4)){
				var ratio:Number = (Menu.HEIGHT-4)/this.width;
				this.width = (Menu.HEIGHT-4);
				this.height = this.height*ratio;
				
			}else if(Menu.HEIGHT>this.width){
				this.x = x + (Menu.HEIGHT-this.width)/2;
			}
			
			if(this.height>(Menu.HEIGHT-4)){
				var yratio:Number = (Menu.HEIGHT-4)/this.height;
				this.height = (Menu.HEIGHT-4);
				this.width = this.width*yratio;
				if(Menu.HEIGHT>this.width){
					this.x = x+ (Menu.HEIGHT-this.width)/2;
				}
				
			}else if((Menu.HEIGHT)>this.height){
				this.y = y + (Menu.HEIGHT-this.height)/2;
			}
			_recycled = isRecycled;
			
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		
	
		public function get recycled():Boolean
		{
			return _recycled;
		}
		public function resetPosition():void{
			this.x=_registeredPoint.x;
			this.y=_registeredPoint.y;
		}

	private function onTouch(t:TouchEvent):void{
		var touch:Touch = t.getTouch(stage);
		if(touch == null){
			return;
		}
		if((touch.phase == TouchPhase.BEGAN)){
			_registeredPoint = new Point(x,y);
			_isDragging = true;
		}
		if(touch.phase == TouchPhase.MOVED && _isDragging){
			this.x = touch.globalX - this.width/2;
			this.y = touch.globalY - this.height/2;
		}
		if(touch.phase == TouchPhase.ENDED){
			_isDragging = false;
			dropped.dispatch(x,y,this);
		}
	}
	
	public function get id():String{
		return _id;
	}
}
}
