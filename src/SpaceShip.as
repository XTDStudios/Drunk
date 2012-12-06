package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import assets.Assets;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	
	public class SpaceShip extends Sprite
	{
		
		private var ps:PDParticleSystem
		private var spaceshipImage:DisplayObject
		private var myTimer:Timer;
		
		private var m_body			: b2Body;
		private var m_fixtureDef	: b2FixtureDef;
		private var m_boxShape		: b2PolygonShape;
		private var m_world			: b2World;
		private var m_bodyDef		: b2BodyDef;

		private var shipWidth		: Number;
		private var shipHeight		: Number;
		
		
		public function SpaceShip(b2dWorld:b2World, spaceshipImage:DisplayObject, position:b2Vec2)
		{

			m_world = b2dWorld;
				
			super();
			createire()
			
			createShip(spaceshipImage, position);
			
			myTimer = new Timer(3000,0);
			myTimer.addEventListener(TimerEvent.TIMER,changeDir)
			myTimer.start()
			
			changeDir();
			startFly()
		}

		
		private function startFly():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			updatePosition();
		}
		
		protected function changeDir(e:TimerEvent = null):void
		{
			var pos : b2Vec2 = m_body.GetPosition();
			m_body.ApplyImpulse(new b2Vec2(100*(Math.random()-pos.x/(Consts.space_size_X/2)), 70*(Math.random()-0.5)),m_body.GetWorldCenter());
		}
		
		
		public function fly():void
		{
			
		}
		
		public function explode():void
		{
			
		}
		
		
		private function createShip(spaceshipImage:DisplayObject, position:b2Vec2):void
		{
			
			this.spaceshipImage = spaceshipImage
				
			shipWidth = spaceshipImage.width/Consts.pixels_in_a_meter/2;
			shipHeight = spaceshipImage.height/Consts.pixels_in_a_meter/2;
			
			// Box
			m_boxShape = new b2PolygonShape();
			m_boxShape.SetAsBox(shipWidth, shipHeight);
			
			m_fixtureDef = new b2FixtureDef();
			m_fixtureDef.shape = m_boxShape;
			m_fixtureDef.density = 1.0;
			m_fixtureDef.friction = 0.5;
			m_fixtureDef.restitution = 0.2;
			m_fixtureDef.userData = "Ship";
			
			m_bodyDef = new b2BodyDef();
			m_bodyDef.type = b2Body.b2_dynamicBody;
			m_bodyDef.userData = spaceshipImage;
			
			// this is the key line, we pass as a userData the starling.display.Quad
			m_body = m_world.CreateBody(m_bodyDef);
			m_body.SetPosition(position);
			m_body.CreateFixture(m_fixtureDef);
			
			addChild(spaceshipImage)
		}
		
		private function createire():void
		{
			// instantiate embedded objects
			var psConfig:XML = XML(new Assets.FireConfig());
			var psTexture:Texture = Texture.fromBitmap(new Assets.FireParticle());
			
			ps = new PDParticleSystem(psConfig, psTexture);
			ps.start();
			Starling.juggler.add(ps);
			addChild(ps);
		}

		
		public function updatePosition():void
		{
			var pos : b2Vec2 = m_body.GetPosition();
			if (pos.x > Consts.space_size_X-(shipWidth*4))
			{
//				m_body.ApplyImpulse(new b2Vec2(0, 0), m_body.GetWorldCenter());
				m_body.SetLinearVelocity(new b2Vec2(0, 0));
				changeDir();
			} else if (pos.x < shipWidth*4)
			{
//				m_body.ApplyImpulse(new b2Vec2(0, 0), m_body.GetWorldCenter());
				m_body.SetLinearVelocity(new b2Vec2(0, 0));
				changeDir();
			}
					
			if (pos.y > Consts.space_size_Y-shipHeight)
			{
				m_body.ApplyImpulse(new b2Vec2(0, -10), m_body.GetWorldCenter());
			} else	if (pos.y < Consts.space_size_Y/2)
			{
				m_body.ApplyImpulse(new b2Vec2(0, 10), m_body.GetWorldCenter());
			}
				
			ps.emitAngle = this.spaceshipImage.rotation + 1;
			ps.emitterX = spaceshipImage.x;
			ps.emitterY = spaceshipImage.y;
		}
	}
}