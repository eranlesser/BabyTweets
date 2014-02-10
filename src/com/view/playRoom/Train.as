package com.view.playRoom
{
	import com.Dimentions;
	import com.view.PlayRoom;
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
	
	public class Train extends PlayItem
	{
		[Embed(source="../../../assets/playroom/train2.png")]
		private var flyBaloon : Class;
		private var _sound:Sound;
		private var _isBackWards:Boolean = true;
		private var _trainImage:Image;
		public function Train(space:Space,cbType:CbType, xx:int, yy:int)
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
			_trainImage =_material.addChild( Image.fromBitmap( new flyBaloon() ) ) as Image;
			_material.addEventListener(TouchEvent.TOUCH,onTouch);
			_sound = new Sound(new URLRequest("../../../assets/sounds/playroom/train2.mp3"));
			var cnl:SoundChannel = _sound.play();
			cnl.stop();
			//_material.pivotX = _material.width >> 1;
			//_material.pivotY = _material.height >> 1;
		}
		private var _climbing:Boolean = false;
		private var _particlesEffect:ParticlesEffect = new ParticlesEffect();
		private function onTouch(e:TouchEvent):void{
			if(e.getTouch(_material.stage) && (e.getTouch(_material.stage).phase == TouchPhase.ENDED)){
				//_material.removeEventListener(TouchEvent.TOUCH,onTouch);
				if(!_climbing){
					_climbing = true;
					if(_isBackWards){
						_body.velocity=(new Vec2(1444,0));
						_particlesEffect.x=_material.width-28;
						//_particlesEffect.rotation=-45;
					}else{
						_body.velocity=(new Vec2(-1444,0));
						_particlesEffect.x=28;
						//_particlesEffect.rotation=45;
					}
					
					_particlesEffect.y=5;
					
					_material.addChild(_particlesEffect);
					_particlesEffect.start("train");
					_sound.play();
					var ref:IAnimatable = Starling.juggler.delayCall(function removeParticles():void{
						_body.gravMassMode = GravMassMode.DEFAULT;
						_particlesEffect.stop();
						_particlesEffect.removeFromParent(true);
						_climbing = false;
						Starling.juggler.remove(ref);
					},1);
				}
			}
		}
		
		override protected function updateGraphics( body : Body ) : void
		{
			body.userData.graphic.x = body.position.x;
			body.userData.graphic.y = body.position.y;
			
			if((body.position.x<=PlayRoom.WALL_WIDTH+10)&&!_isBackWards){
				_isBackWards=true;
				_trainImage.scaleX=1;
				_trainImage.x=0;
				_particlesEffect.x=_trainImage.width-44;
				_particlesEffect.rotation=-45;
				_body.velocity=(new Vec2(1222,0));
			}else if((body.position.x>=Dimentions.WIDTH-PlayRoom.WALL_WIDTH-10-_material.width)&&_isBackWards){
				_isBackWards=false;
				
				_trainImage.scaleX=-1;
				_trainImage.x=_trainImage.width;
				_particlesEffect.x=44;
				_particlesEffect.rotation=45;
				_body.velocity=(new Vec2(-1222,0));
			}
			//if(body.rotation>-0.5 && body.rotation<0.5)
			//body.userData.graphic.rotation = body.rotation;
		}
	}
}