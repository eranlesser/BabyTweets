package
{
	import com.Dimentions;
	import com.model.Session;
	import com.utils.errorHandlers.GlobalExceptionHandler;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	
	[SWF( frameRate="60", backgroundColor="#F2D399")]
	
	public class hworld extends Sprite
	{
		
		
		private var _starling:Starling;
		public function hworld()
		{
			super();
			if(stage){
				init(null);
			}else{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
			//var obj:DisplayObject =addChild(new Stats());
			//obj.y=80
			// support autoOrients
			
			//Flurry.getInstance().setIOSAPIKey("FGJG54WS4ZBX3DYR8T8Q");
			//Flurry.getInstance().startSession();
			
		}
		
		private function init(e:Event):void{
			new GlobalExceptionHandler(loaderInfo);
			var viewPort:Rectangle = new Rectangle(0, 0, Dimentions.WIDTH, Dimentions.HEIGHT)
			setDisplaySize();
			
			//starling = new Starling(Game, stage, viewPort);
			
			Starling.multitouchEnabled = true;
			//Starling.handleLostContext = true;
			_starling = new Starling(FirstWordsApp,stage,viewPort);
			//_starling.showStats=true;
			_starling.start();
			Starling.current.nativeStage.align = StageAlign.TOP_LEFT;
			Starling.current.nativeStage.scaleMode = StageScaleMode.NO_SCALE;
			Starling.current.nativeStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, orientationChange);
			var delayCall:DelayedCall = Starling.juggler.delayCall(setDisplaySize,0.5);
			delayCall.repeatCount = 8;
			Session.init();
		}
		
		private function setDisplaySize():void{
			var wdt:int = Math.max(stage.fullScreenWidth,stage.fullScreenHeight);
			var hgt:int = Math.min(stage.fullScreenWidth,stage.fullScreenHeight);
			if(wdt==1024 || wdt == 2048){
				Session.deviceId = 2;
			}else{
				Session.deviceId=1;
			}
			if(_starling && (_starling.viewPort.width != wdt || _starling.viewPort.height != hgt)){
				_starling.viewPort = new Rectangle(0,0,wdt,hgt);
				if(wdt==1024 || wdt == 2048){
					Session.deviceId = 2;
				}else{
					Session.deviceId=1;
				}
			}
			
		}
		
		private function orientationChange(e:StageOrientationEvent):void{
			if (e.afterOrientation != StageOrientation.ROTATED_LEFT && e.afterOrientation != StageOrientation.ROTATED_RIGHT)
			{
				e.preventDefault();
			}
		}
	}
	
	
}