package
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Astroid extends Sprite
	{
		private var m_body			: b2Body;
		private var m_fixtureDef	: b2FixtureDef;
		private var m_boxShape		: b2PolygonShape;
		private var m_world			: b2World;
		
		private var m_bodyDef:b2BodyDef;
		
		public function Astroid(b2dWorld:b2World, image:Image, position:b2Vec2)
		{
			m_world = b2dWorld;
			super();	
			
			addChild(image);
			
			var AstroidWidth  : Number = image.width/Consts.pixels_in_a_meter/2;
			var AstroidHeight : Number = image.height/Consts.pixels_in_a_meter/2;
			
			// Box
			m_boxShape = new b2PolygonShape();
			m_boxShape.SetAsBox(AstroidWidth, AstroidHeight);
			
			m_fixtureDef = new b2FixtureDef();
			m_fixtureDef.shape = m_boxShape;
			m_fixtureDef.density = 1.0;
			m_fixtureDef.friction = 0.5;
			m_fixtureDef.restitution = 0.2;
			m_fixtureDef.userData = "Astroid";
			
			m_bodyDef = new b2BodyDef();
			m_bodyDef.type = b2Body.b2_dynamicBody;
			m_bodyDef.userData = this;
			
			// this is the key line, we pass as a userData the starling.display.Quad
			m_body = m_world.CreateBody(m_bodyDef);
			m_body.SetPosition(position);
			m_body.CreateFixture(m_fixtureDef);

			m_body.ApplyImpulse(new b2Vec2(20*(Math.random()-0.5), 50*Math.random()),m_body.GetWorldCenter());
		}
		
	}
}