package
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import assets.Assets;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Astroid extends Image
	{
		private var m_body			: b2Body;
		private var m_fixtureDef	: b2FixtureDef;
		private var m_boxShape		: b2PolygonShape;
		
		public function Astroid(b2dWorld:b2World)
		{
			var texture : Texture = Texture.fromBitmap(new Assets.AstroidGFX());
			super(texture);	
			width = 50;
			height = 50;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			
			bodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = this;
				
			// Box
			m_boxShape = new b2PolygonShape();
			m_boxShape.SetAsBox(1, 1);
			
			m_fixtureDef = new b2FixtureDef();
			m_fixtureDef.shape = m_boxShape;
			m_fixtureDef.density = 1.0;
			m_fixtureDef.friction = 0.5;
			m_fixtureDef.restitution = 0.2;
			
			// this is the key line, we pass as a userData the starling.display.Quad
			m_body = b2dWorld.CreateBody(bodyDef);
			m_body.CreateFixture(m_fixtureDef);
		}
	}
}