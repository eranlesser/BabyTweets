package com.view.components
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	
	public class ParticlesEffect extends Sprite
	{
		[Embed(source="../../../assets/media/stars/stars.pex", mimeType="application/octet-stream")]
		private static const DrugsConfig:Class;
		[Embed(source="../../../assets/media/fire.pex", mimeType="application/octet-stream")]
		private static const FireConfig:Class;
		[Embed(source="../../../assets/media/sun.pex", mimeType="application/octet-stream")]
		private static const SunConfig:Class;
		[Embed(source="../../../assets/media/jellyfish.pex", mimeType="application/octet-stream")]
		private static const JellyfishConfig:Class;
		[Embed(source="../../../assets/media/baloon.pex", mimeType="application/octet-stream")]
		private static const balloonConfig:Class;
		[Embed(source="../../../assets/media/train/particle.pex", mimeType="application/octet-stream")]
		private static const trainConfig:Class;
		[Embed(source="../../../assets/media/touchstar/particle.pex", mimeType="application/octet-stream")]
		private static const touchStarConfig:Class;
		[Embed(source = "../../../assets/media/stars/stars.png")]
		private static const DrugsParticle:Class;
		[Embed(source = "../../../assets/media/fire_particle.png")]
		private static const FireParticle:Class;
		[Embed(source = "../../../assets/media/sun_particle.png")]
		private static const SunParticle:Class;
		[Embed(source = "../../../assets/media/jellyfish_particle.png")]
		private static const JellyfishParticle:Class;
		[Embed(source = "../../../assets/media/baloon.png")]
		private static const baloonAsset:Class;
		[Embed(source = "../../../assets/media/train/texture.png")]
		private static const trainAsset:Class;
		[Embed(source = "../../../assets/media/touchstar/texture.png")]
		private static const touchstarAsset:Class;
		
		private var _mParticleSystem:ParticleSystem;
		public function ParticlesEffect()
		{
			
		}
		public function start(type:String):void{
			
			switch(type){
				case "drug":
					var drugsConfig:XML = XML(new DrugsConfig());
					var drugsTexture:Texture = Texture.fromBitmap(new DrugsParticle());
					_mParticleSystem = new PDParticleSystem(drugsConfig, drugsTexture);
					alpha=1;
					break;
				case "fire":
					var fireConfig:XML = XML(new FireConfig());
					var fireTexture:Texture = Texture.fromBitmap(new FireParticle());
					_mParticleSystem = new PDParticleSystem(fireConfig, fireTexture);
					alpha=0.5;
					break;
				case "sun":
					var sunConfig:XML = XML(new SunConfig());
					var sunTexture:Texture = Texture.fromBitmap(new SunParticle());
					_mParticleSystem = new PDParticleSystem(sunConfig, sunTexture);
					alpha=0.02;
					break;
				case "jfish":
					var jellyConfig:XML = XML(new JellyfishConfig());
					var jellyTexture:Texture = Texture.fromBitmap(new JellyfishParticle());
					_mParticleSystem = new PDParticleSystem(jellyConfig, jellyTexture);
					alpha=0.4;
					break;
				case "baloon":
					var balloonXml:XML = XML(new balloonConfig());
					var balloonTexture:Texture = Texture.fromBitmap(new baloonAsset());
					_mParticleSystem = new PDParticleSystem(balloonXml, balloonTexture);
					alpha=0.8;
					break;
				case "train":
					var trainXml:XML = XML(new trainConfig());
					var trainTexture:Texture = Texture.fromBitmap(new trainAsset());
					_mParticleSystem = new PDParticleSystem(trainXml, trainTexture);
					break;
				case "touchstar":
					var touchstarXml:XML = XML(new touchStarConfig());
					var touchstarTexture:Texture = Texture.fromBitmap(new touchstarAsset());
					_mParticleSystem = new PDParticleSystem(touchstarXml, touchstarTexture);
					alpha=0.8;
					break;
			}
			
			_mParticleSystem.emitterX = width;
			_mParticleSystem.emitterY = height;
			_mParticleSystem.start();
			
			addChild(_mParticleSystem);
			Starling.juggler.add(_mParticleSystem);
		}
		
		public function stop():void{
			_mParticleSystem.stop(true);
			_mParticleSystem.dispose();
			_mParticleSystem.removeFromParent(true);
		}
	}
}