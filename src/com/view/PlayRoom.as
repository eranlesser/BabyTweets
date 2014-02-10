package com.view
{
	import com.Dimentions;
	import com.model.ScreenModel;
	import com.view.playRoom.Baloon;
	import com.view.playRoom.BasketBall;
	import com.view.playRoom.Book;
	import com.view.playRoom.Cube;
	import com.view.playRoom.Drawing;
	import com.view.playRoom.FlyBaloon;
	import com.view.playRoom.Horse;
	import com.view.playRoom.Menu;
	import com.view.playRoom.Plane;
	import com.view.playRoom.Train;
	import com.view.utils.SoundPlayer;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.AccelerometerEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.sensors.Accelerometer;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.constraint.PivotJoint;
	import nape.dynamics.Arbiter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class PlayRoom extends AbstractScreen
	{
		private static const GRAVITY_X : Number = 0;
		private static const GRAVITY_Y : Number = 3000;
		
		private static const STEP_TIME : Number = 0.01;
		private var _room:Sprite;
		
		[Embed(source="../../assets/playroom/bg.png")]
		private var Background:Class;
		[Embed(source="../../assets/playroom/broom.png")]
		private var broom:Class;
		
		
		private var _nativeStage : Stage;
		private var _space : Space;
		private var _hand : PivotJoint;
		
		private var _ballCollisionType:CbType = new CbType();
		private var _cubeCollisionType:CbType = new CbType();
		private var _floorCollisionType:CbType = new CbType();
		private var _baloonCollisionType:CbType = new CbType();
		private var _baloonPopCollisionType:CbType = new CbType();
		private var _menu:Menu;
		private var _delayer:DelayedCall;
		private var _sound:Sound;
		public function PlayRoom()
		{
			
			//new Sound(new URLRequest(heb/playRoom.mp3"));
			
		}
		
		public function set noTimer(val:Boolean):void{
			if(val){
				Starling.juggler.remove(_delayer);
			}
		}
		
		override public function destroy():void{
			Starling.juggler.remove(_delayer);
		}
		private function finish():void{
			closeCurtains();
			Starling.juggler.delayCall(dispatchDone,2);
//			var counter:uint = 0;
//			_hinter = Starling.juggler.delayCall(
//				function onShowHint():void{
//					_arrowHint.visible = !_arrowHint.visible;
//					counter++;
//					if(counter==10){
//						//done.dispatch();
//					}
//				},0.5
//				
//			);
//			_hinter.repeatCount=0;
		}
		
		
		private function init() : void
		{
			_delayer = Starling.juggler.delayCall(finish,22);
			_delayer.repeatCount = 1;
			var soundPlayer:SoundPlayer = new SoundPlayer();
			_sound = soundPlayer.getSound("../assets/narration/","/playRoom.mp3");
			_sound.play();
			if(!_menu){
				var broomBut:Button = new Button(Texture.fromBitmap(new broom()));
				broomBut.addEventListener(Event.TRIGGERED,clean);
				addChild(broomBut);
				broomBut.x=Dimentions.WIDTH-broomBut.width-8;
				broomBut.y=4;
				broomBut.scaleY=0.75;
				_nativeStage = Starling.current.nativeStage;
				
				addBackground();
				createSpace();
				createHand();
				listenForMouseDown();
				listenForMouseUp();
				listenForEnterFrame();
				useAccelerometer();
				_space.listeners.add(new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_floorCollisionType,_cubeCollisionType,ballToCube));
				_space.listeners.add(new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_ballCollisionType,_cubeCollisionType,ballToFloor));
				_space.listeners.add(new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_ballCollisionType,_floorCollisionType,ballToFloor));
				_space.listeners.add(new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_baloonCollisionType,_baloonPopCollisionType,baloonPop));
				_space.listeners.add(new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_baloonPopCollisionType,_ballCollisionType,ballToFloor));
				
				_menu = new Menu();
				_screenLayer.addChild(_menu);
				_menu.x = (Dimentions.WIDTH - _menu.width)/2;
				_menu.itemDropped.add(onMenuItemDropped);
				
				createFloor();
			}
			//tmr.start();
		}
		
		override public function set model(screenModel:ScreenModel):void{
			init();
			_menu.model = screenModel;
		}
		private var _balloons:Vector.<Baloon> = new Vector.<Baloon>();
		private function onMenuItemDropped(x:int,y:int,id:String):void{
			
			//Flurry.getInstance().logEvent("playroom "+id);
			switch(id){
				case "ball":
					var ball:BasketBall = new BasketBall(_space,_ballCollisionType,x,y);
					_room.addChild( ball.material);
					break;
				case "cubes":
					_room.addChild(new Cube(_space,_cubeCollisionType,x-40,y,1).material);
					_room.addChild(new Cube(_space,_cubeCollisionType,x+40,y,2).material);
					_room.addChild(new Cube(_space,_cubeCollisionType,x,y-80,3).material);
					break;
				case "bluBln":
					var baloon:Baloon = new Baloon(_space,_baloonCollisionType,x,y);
					_room.addChild(baloon.material);
					baloon.material.addEventListener(TouchEvent.TOUCH,function onTouch(e:TouchEvent):void{
						//if(baloon.material.stage == null){
							_hand.active = false;
						//}
					});
					_balloons.push(baloon);
					break;
				case "fly_baloon":
					var bln:FlyBaloon = new FlyBaloon(_space,_baloonPopCollisionType,x,y);
					_room.addChild(bln.material);
					bln.fly();
					break;
				case "plane":
					var plane:Plane = new Plane(_space,_baloonPopCollisionType,x,y);
					_room.addChild(plane.material);
					plane.fly();
					break;
				case "train2":
					_room.addChild(new Train(_space,_baloonPopCollisionType,x,y).material);
					break;
				case "book":
					_room.addChild(new Book(_space,_baloonPopCollisionType,x,y).material);
					break;
				case "horse":
					_room.addChild(new Horse(_space,null,x,y).material);
					break;
				case "drawing":
					var drawing:Drawing = new Drawing();
					_room.addChildAt(drawing,1);
					drawing.x=x;
					drawing.y=y;
					break;
			}
			
			//_menu.visible = false;
		}
		
		
		private function clean(e:Event):void{
			var lngt:uint = _space.bodies.length;
			if (lngt>0) {
				for (var i:int = 0; i < lngt; i++) {
					// getting the body
					var body:Body=_space.bodies.at(0);
					_space.bodies.remove(body);
				}
			}
			_room.removeChildren(1);
			createFloor();
			_menu.reset();
		}
		
		private function ballToCube(collision:InteractionCallback):void {
			collision.arbiters.foreach(function(arb:Arbiter):void {
				if(Math.abs(arb.collisionArbiter.body2.velocity.x)>300 || Math.abs(arb.collisionArbiter.body2.velocity.y)>320){
					new Sound(new URLRequest("../../assets/sounds/playroom/cube.mp3")).play();
				}
			});
		}
		private function ballToFloor(collision:InteractionCallback):void {
			collision.arbiters.foreach(function(arb:Arbiter):void {
				if(Math.abs(arb.collisionArbiter.body2.velocity.x)>400 || Math.abs(arb.collisionArbiter.body2.velocity.y)>400){
					new Sound(new URLRequest("../../assets/sounds/playroom/boing.mp3")).play();
				}
			});
			
		}
		private function baloonPop(collision:InteractionCallback):void {
			
			for each(var baloon:Baloon in _balloons){
				if(baloon.body == collision.int1){
					baloon.pop();
				}
			}
		}
		
		private function addBackground() : void
		{
			drawDarkBg();
			_room = new Sprite();
			_room.addChild( Image.fromBitmap( new Background() ) );
//			_room.addChild( Image.fromBitmap( new bed() ) );
//			_room.addChild( Image.fromBitmap( new shelf() ) );
//			_room.addChild( Image.fromBitmap( new lamp() ) );
//			_room.addChild( Image.fromBitmap( new light() ) );
//			_room.addChild( Image.fromBitmap( new leftBoard() ) );
//			_room.addChild( Image.fromBitmap( new winBg() ) );
//			_room.addChild( Image.fromBitmap( new win() ) );
//			_room.addChild( Image.fromBitmap( new box() ) );
			//var rightBoard:Image = addChild( Image.fromBitmap( new rightBoard() ) ) as Image;
			_screenLayer.addChild(_room);
			//_room.alpha=0.1;
			//rightBoard.addEventListener(TouchEvent.TOUCH,onRightBoardTouch);
		}
		
		private function drawDarkBg():void{
			var shp:Shape = new Shape();
			shp.graphics.beginFill(0x333333);
			shp.graphics.drawRect(0,0,Dimentions.WIDTH,Dimentions.HEIGHT);
			shp.graphics.endFill();
			var bmp:BitmapData = new BitmapData(Dimentions.WIDTH,Dimentions.HEIGHT,true,0x333333);
			bmp.draw(shp)
			var txture:Texture = Texture.fromBitmapData(bmp);
			var img:Image = new Image(txture);
			_screenLayer.addChild(img);
		}
		
		private function onRightBoardTouch(e:TouchEvent):void{
			var touch:Touch = e.getTouch(stage);
			if(touch.phase == TouchPhase.MOVED){
				var shp:Shape = new Shape();
				shp.graphics.beginFill(0x333333);
				shp.graphics.drawCircle(0,0,2);
				shp.graphics.endFill();
				var bmp:BitmapData = new BitmapData(4,4,true,0x333333);
				bmp.draw(shp)
				var txture:Texture = Texture.fromBitmapData(bmp);
				var img:Image = new Image(txture);
				_screenLayer.addChild(img);
				img.x=touch.globalX;
				img.y=touch.globalY;
			}
		}
		
		private function createSpace():void
		{
			_space = new Space( new Vec2( GRAVITY_X, GRAVITY_Y ) );
		}
		public static const WALL_WIDTH:uint=22;
		private function createFloor():void
		{
			const floor:Body = new Body( BodyType.STATIC );
			
			// what are all these things?
			floor.shapes.add( new Polygon( Polygon.rect( 0, 768 - Menu.HEIGHT - 2-30, 1024, 200 ) ) );
			floor.shapes.add( new Polygon( Polygon.rect( 1024-WALL_WIDTH, 0, WALL_WIDTH, 768 ) ) );
			floor.shapes.add( new Polygon( Polygon.rect( 0, -20, 1024, 22 ) ) );
			floor.shapes.add( new Polygon( Polygon.rect( 0, 0, WALL_WIDTH, 768 ) ) );
			
			floor.space = _space;
			floor.cbTypes.add(_floorCollisionType);
		}
		
		private function createHand():void
		{
			_hand = new PivotJoint( _space.world, null, new Vec2(), new Vec2() );
			_hand.active = false;
			_hand.stiff = false;
			_hand.space = _space;
		}
		
		private function listenForMouseDown():void
		{
			_nativeStage.addEventListener( MouseEvent.MOUSE_DOWN, function( event : MouseEvent ) : void
			{
				var mousePoint : Vec2 = new Vec2( event.stageX, event.stageY );
				var bodies : BodyList = _space.bodiesUnderPoint( mousePoint );
				
				if ( bodies.length > 0 )
				{
					var body : Body = bodies.shift();
					_hand.body2 = body;
					_hand.anchor2 = body.worldPointToLocal( mousePoint );
					if(body.type == BodyType.DYNAMIC){
						_hand.active = true;
					}
				}
			});
		}
		
		private function listenForMouseUp():void
		{
			_nativeStage.addEventListener( MouseEvent.MOUSE_UP, function( event : MouseEvent ) : void
			{
				_hand.active = false;
			});
		}
		
		private function listenForEnterFrame() : void
		{
			addEventListener( Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void{
			if(visible){
				_hand.anchor1.setxy( _nativeStage.mouseX, _nativeStage.mouseY );
				_space.step( STEP_TIME );
				for (var i:int = 0; i < _space.liveBodies.length; i++) {
					var body:Body = _space.liveBodies.at(i);
					if (body.userData.graphicUpdate) {
						body.userData.graphicUpdate(body);
					}
				}
			}
		}
		
		private function useAccelerometer():void
		{
			var accelerometer : Accelerometer = new Accelerometer();
			accelerometer.addEventListener( AccelerometerEvent.UPDATE, function( event : AccelerometerEvent ) : void
			{
				_space.gravity = new Vec2( -event.accelerationX * 5000, GRAVITY_Y );
			});
		}
		
		
		
		
		
		
	}
}