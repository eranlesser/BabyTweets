package com.view.components
{
	import com.Assets;
	import com.Dimentions;
	import com.model.ScreenModel;
	import com.model.ScreensModel;
	import com.model.Session;
	import com.view.menu.Store;
	
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class ScreensMenu extends Sprite
	{
		private var _screenThumbs:Vector.<ThumbNail> = new Vector.<ThumbNail>();
		private var _thumbs:Sprite;
		public var gotoSignal:Signal = new Signal();
		private var _storeBtn:Button;
		private var _store:Store;
		
		[Embed(source="../../../assets/unlock.png")]
		private var unlock : 			Class;
		
		[Embed(source="../../../assets/menu/about.png")]
		private var about : 			Class;
		
		public function ScreensMenu(screens:ScreensModel)
		{
			_thumbs = new Sprite();
			addChild(_thumbs);
			screens.changed.add(init);
			initFullVersionBtn();
			Session.changed.add(onsessionChanged);
			init(screens);
		}
		
		
		
		private function onsessionChanged():void{
			trace("onsessionChanged","Session.fullVersionEnabled",Session.fullVersionEnabled)
			for(var i:uint = 0;i<_screenThumbs.length;i++){
				(_screenThumbs[i]).locked=false;
			}
			if(_store && _store.parent == this){
				removeChild(_store);
			}
			_storeBtn.visible=false;
		}
		
		private function init(screens:ScreensModel):void
		{
			
			var i:int=0;
			var n:int=0;
			var wdt:uint=170;
			var hgt:uint=136;
			var gap:uint=12;
			var menuThmb:ThumbNail;
			_thumbs.removeChildren(0,-1,true);
			_screenThumbs = new Vector.<ThumbNail>();
			for each(var screen:ScreenModel in screens.screens){
				if(screen.thumbNail!=""){
					menuThmb = new ThumbNail(Assets.getAtlas("thumbs").getTexture(screen.thumbNail),i);
					_screenThumbs.push(menuThmb);
					menuThmb.x = (n%4)*wdt + (n%4)*gap;//menuThmb.x-5;
					menuThmb.y = Math.floor(n/4)*(hgt+gap)+110;//menuThmb.y-5;
					_thumbs.addChild(menuThmb);
					menuThmb.addEventListener(TouchEvent.TOUCH,onMenuThumbTouch);
					n++;
				}//if
				i++;
			}//for
			_thumbs.x=(Dimentions.WIDTH - _thumbs.width)/2
			setSelectedScreen();
			
		}
		
		private function initFullVersionBtn():void{
			if(Session.fullVersionEnabled==false){
				var btnUpState:Texture = Texture.fromBitmap(new unlock())
				_storeBtn = new Button(btnUpState);
				addChild(_storeBtn);
				_storeBtn.x= Dimentions.WIDTH - _storeBtn.width -5;
				_storeBtn.y=10; // iphone 100 , ipad 72
				_storeBtn.addEventListener(starling.events.Event.TRIGGERED,onStore);
			}
		}
		private function onStore():void
		{
			// TODO Auto Generated method stub
			if(!_store){
				_store = new Store();
				_store.goHome.add(function():void{
					removeChild(_store);
				});
			}
			addChild(_store);
			//_store.buyFullVersion();
		}
		//function
		
		
		private function onMenuThumbTouch(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			if(touch && (touch.phase == TouchPhase.BEGAN)){
				var thmbNail:ThumbNail = ThumbNail(e.currentTarget);
				if(thmbNail.locked){
					onStore();
				}else{
					gotoSignal.dispatch(thmbNail.index);
				}
			}
		}
		
		public function setSelectedScreen():void{
			for(var i:uint = 0;i<_screenThumbs.length;i++){ // subtract restore btn
				if(i>Session.FREE_THUMBS_COUNT-1 && i != _screenThumbs.length-1 && !Session.fullVersionEnabled){//apply lock
					(_screenThumbs[i]).locked=true;
				}else{
					(_screenThumbs[i]).locked=false;
				}
				if(_screenThumbs[i].index==Session.currentScreen){//apply selected screen
					_screenThumbs[i].selected = true;
				}else{
					_screenThumbs[i].selected = false;
				}
			}
		}
		
		
		
		
		
		
	}
}


import com.Assets;
import com.utils.filters.GlowFilter;

import flash.display.BitmapData;
import flash.display.Shape;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

class ThumbNail extends Sprite{
	public var index:int;
	private var _btn:Image;
	private var _selectedFrame:Image;
	private var _lock:Image;
	function ThumbNail(asset:Texture,indx:int){
		var frame:Image = new Image((getFrame(1)))
		_selectedFrame = new Image((getFrame(2)))
		_selectedFrame.filter=new GlowFilter(0x041626,1,12,12);
		addChild(frame);
		addChild(_selectedFrame);
		_selectedFrame.visible=false;
		_btn = new Image(asset);
		addChild(_btn)
		_btn.x=(frame.width-_btn.width)/2;
		_btn.y=(frame.height-_btn.height)/2;
		
		_lock = new Image(Texture.fromBitmap(new Assets.Lock));
		_lock.x=(frame.width-_lock.width)+4;
		_lock.y=(frame.height-_lock.height)+4;
		_lock.alpha=0.9;
			//_lock.filter = new GlowFilter(0xEDFF19,1,6,6);
		addChild(_lock);
		_lock.touchable=false;
		index=indx;
		
	}
	
	private function getFrame(lineWidth:uint):Texture{
			var nBox:Shape = new Shape();
			nBox.graphics.lineStyle(1,0x008DB2)
			nBox.graphics.beginFill(0xFFFFFF);
			nBox.graphics.drawRect(0,0,170,136);
			nBox.graphics.endFill();
			
			var nBMP_D:BitmapData = new BitmapData(172, 138, true, 0x00000000);
			nBMP_D.draw(nBox);
			
			var nTxtr:Texture = Texture.fromBitmapData(nBMP_D, false, false);
			return nTxtr;
	}
	
	public function set selected(val:Boolean):void{
		_selectedFrame.visible=val;
	}
	
	public function set locked(val:Boolean):void{
		_lock.visible=val;
	}
	
	public function get locked():Boolean{
		return _lock.visible;
	}
	
}