package com.view.playRoom
{
	import com.view.components.ParticlesEffect;
	
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Baloon extends PlayItem
	{
		[Embed(source="../../../assets/balloons/bluBln.png")]
		private var bluBln : Class;
		[Embed(source="../../../assets/balloons/greenBln.png")]
		private var greenBln : Class;
		[Embed(source="../../../assets/balloons/orangeBln.png")]
		private var orangeBln : Class;
		[Embed(source="../../../assets/balloons/redBln.png")]
		private var redBln : Class;
		[Embed(source="../../../assets/balloons/turkuizeBln.png")]
		private var turkuizeBln : Class;
		[Embed(source="../../../assets/balloons/yellowBln.png")]
		private var yellowBln : Class;
		private var _popAble:Boolean=false;
		private var _sound:Sound;
		public function Baloon(space:Space, cbType:CbType, xx:int, yy:int)
		{
			super(space, cbType, xx, yy);
		}
		
		override protected function createBody(cbType:CbType,xx:int,yy:int):void{
			_body = new Body( BodyType.DYNAMIC, new Vec2( xx, yy ) );
			_body.shapes.add( new Polygon( Polygon.rect(0,0,_material.width,_material.height), Material.wood() ) );
			_body.gravMass = -0.1;
			super.createBody(cbType,xx,yy);
			
		}
		
		public function get body():Body{
			return _body;
		}
		
		override protected function createMaterial():void{
			_material = new Sprite();
			var btnmp:Bitmap;
			var rand:Number = Math.random()*6;
			if(rand<1){
				btnmp = new bluBln();
			}else if(rand<2){
				btnmp = new greenBln();
				
			}else if(rand<3){
				btnmp = new orangeBln();
				
			}else if(rand<4){
				btnmp = new redBln();
				
			}else if(rand<5){
				btnmp = new turkuizeBln();
				
			}else if(rand<6){
				btnmp = new yellowBln();
				
			}
			_material.addChild( Image.fromBitmap( btnmp ) ) as Sprite;
			_sound = new Sound(new URLRequest("../../../assets/sounds/playroom/pop.mp3"));
			var cnl:SoundChannel = _sound.play();
			cnl.stop();
			Starling.juggler.delayCall(function():void{
			_material.addEventListener(TouchEvent.TOUCH,onTouch);
			_popAble=true;
			},2);
			//_material.pivotX = _material.width >> 1;
			//_material.pivotY = _material.height >> 1;
		}
		
		
		public function pop():void{
			if(!_popAble ){
				return;
			}
			var _particlesEffect:ParticlesEffect;
			_particlesEffect = new ParticlesEffect();
			_particlesEffect.width=_material.width/10;
			_particlesEffect.height=_material.height/10;
			_particlesEffect.x=_material.x+_material.width/2;
			_particlesEffect.y=_material.y+_material.height/2;
			_material.parent.addChild(_particlesEffect);
			_particlesEffect.start("jfish");
			_sound.play();
			Starling.juggler.delayCall(function removeParticles():void{
				_particlesEffect.stop();
				_particlesEffect.removeFromParent(true)
			},0.3);
			_material.removeFromParent(true);
			_space.bodies.remove(_body);
		}
		private function onTouch(e:TouchEvent):void{
			if(e.getTouch(_material.stage).phase == TouchPhase.BEGAN){
				_material.removeEventListener(TouchEvent.TOUCH,onTouch);
				pop();
			}
		}
	}
}