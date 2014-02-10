package com.view.playRoom
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Horse extends PlayItem
	{
		[Embed(source="../../../assets/playroom/horse.png")]
		private var horse : Class;
		private var _sound:Sound;
		private static const BALL_RADIUS : Number = 120; // TODO make dynamic
		private static const BALL_ELASTICITY : Number = 1.5;
		
		public function Horse(space:Space,cbType:CbType,xx:int,yy:int)
		{
			super(space,cbType,xx,yy);
			
		}
		
		override protected function createBody(cbType:CbType,xx:int,yy:int):void{
			_body = new Body( BodyType.DYNAMIC, new Vec2( xx, yy ) );
			_body.shapes.add( new Circle( BALL_RADIUS, null, Material.wood() ) );
			_body.shapes.add( new Polygon( Polygon.rect(-100,0,BALL_RADIUS*2,50) ) );
			super.createBody(cbType,xx,yy);
		}
		
		override protected function createMaterial():void{
			_material = new Sprite();
			_material.addChild( Image.fromBitmap( new horse() ) ) as Sprite;
			_material.pivotX = _material.width >> 1;
			_material.pivotY = _material.height >> 1;
			_sound = new Sound(new URLRequest("../../../assets/sounds/playroom/cube.mp3"));
			var cnl:SoundChannel = _sound.play();
			cnl.stop();
		}
		private var _dir:String="left";
		override protected function updateGraphics(body:Body):void{
			super.updateGraphics(body);
			if(body.rotation>0.6&&_dir=="left"){
				_body.velocity=(new Vec2(-200,0));
				_dir="right";
				_sound.play();
			}
			if(body.rotation<-0.22&&_dir=="right"){
				_body.velocity=(new Vec2(200,0));
				_dir="left";
				_sound.play();
			}
			
			trace(body.rotation)
		}
		
		
	}
}