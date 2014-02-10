package com.view.playRoom
{
	import com.view.components.ParticlesEffect;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.GravMassMode;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class FlyBaloon extends PlayItem
	{
		[Embed(source="../../../assets/playroom/fly_baloon.png")]
		private var flyBaloon : Class;
		private var _sound:Sound;
		public function FlyBaloon(space:Space,cbType:CbType, xx:int, yy:int)
		{
			super(space,  cbType, xx, yy);
		}
		
		override protected function createBody(cbType:CbType,xx:int,yy:int):void{
			_body = new Body( BodyType.DYNAMIC, new Vec2( xx, yy ) );
			_body.shapes.add( new Polygon( Polygon.rect(0,0,_material.width,_material.height), Material.wood() ) );
			_body.allowRotation = false;
			super.createBody(cbType,xx,yy);
			
		}
		
		override protected function createMaterial():void{
			_material = new Sprite();
			_material.addChild( Image.fromBitmap( new flyBaloon() ) ) as Sprite;
			_material.addEventListener(TouchEvent.TOUCH,onTouch);
			_sound = new Sound(new URLRequest("../../../assets/sounds/playroom/wind.mp3"));
			var cnl:SoundChannel = _sound.play();
			cnl.stop();
			//_material.pivotX = _material.width >> 1;
			//_material.pivotY = _material.height >> 1;
		}
		private var _climbing:Boolean = false;
		private var _particlesEffect:ParticlesEffect = new ParticlesEffect();
		private function onTouch(e:TouchEvent):void{
			if(e.getTouch(_material.stage).phase == TouchPhase.ENDED){
				//_material.removeEventListener(TouchEvent.TOUCH,onTouch);
				fly();
			}
		}
		
		public function fly():void{
			if(!_climbing){
				_climbing = true;
				_body.gravMass = -0.6;
				_particlesEffect.x=_material.width/2;
				_particlesEffect.y=_material.height/2;
				_material.addChildAt(_particlesEffect,0);
				_particlesEffect.start("baloon");
				_sound.play();
				var ref:IAnimatable = Starling.juggler.delayCall(function removeParticles():void{
					_body.gravMassMode = GravMassMode.DEFAULT;
					_particlesEffect.stop();
					_particlesEffect.removeFromParent(true);
					_climbing = false;
					Starling.juggler.remove(ref);
				},8);
			}
		}
		override protected function updateGraphics( body : Body ) : void
		{
			body.userData.graphic.x = body.position.x;
			body.userData.graphic.y = body.position.y;
			//if(body.rotation>-0.5 && body.rotation<0.5)
			//body.userData.graphic.rotation = body.rotation;
		}
	}
}