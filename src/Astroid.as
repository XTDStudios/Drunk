package
{
	import Box2D.Collision.Shapes.b2PolygonShape;
<<<<<<< HEAD
=======
	import Box2D.Common.Math.b2Vec2;
>>>>>>> 179a1e55716e21392c4a81c2713d003a2cea4681
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import assets.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Astroid extends Sprite
	{
		private var m_body			: b2Body;
		private var m_fixtureDef	: b2FixtureDef;
		private var m_boxShape		: b2PolygonShape;
<<<<<<< HEAD
		
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
=======
		private var m_world			: b2World;
		private var m_image			: Image;
		
		private var m_bodyDef:b2BodyDef;
		
		public function Astroid(b2dWorld:b2World, position:b2Vec2)
		{
			m_world = b2dWorld;
			super();	
			
			var texture : Texture = Texture.fromBitmap(new Assets.AstroidGFX());
			m_image = new Image(texture);
			addChild(m_image);
			
			m_image.width = 50;
			m_image.height = 60;
			
			m_image.x = -width/2.0;
			m_image.y = -height/2.0;

			var AstroidWidth  : Number = m_image.width/Consts.pixels_in_a_meter/2;
			var AstroidHeight : Number = m_image.height/Consts.pixels_in_a_meter/2;
			
			// Box
			m_boxShape = new b2PolygonShape();
			m_boxShape.SetAsBox(AstroidWidth, AstroidHeight);
>>>>>>> 179a1e55716e21392c4a81c2713d003a2cea4681
			
			m_fixtureDef = new b2FixtureDef();
			m_fixtureDef.shape = m_boxShape;
			m_fixtureDef.density = 1.0;
			m_fixtureDef.friction = 0.5;
			m_fixtureDef.restitution = 0.2;
			
<<<<<<< HEAD
			// this is the key line, we pass as a userData the starling.display.Quad
			m_body = b2dWorld.CreateBody(bodyDef);
=======
			m_bodyDef = new b2BodyDef();
			m_bodyDef.type = b2Body.b2_dynamicBody;
			m_bodyDef.userData = this;
			
			// this is the key line, we pass as a userData the starling.display.Quad
			m_body = m_world.CreateBody(m_bodyDef);
			m_body.SetPosition(position);
>>>>>>> 179a1e55716e21392c4a81c2713d003a2cea4681
			m_body.CreateFixture(m_fixtureDef);
		}
		
	}
}