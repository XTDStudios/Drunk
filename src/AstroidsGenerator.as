package
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;

	public class AstroidsGenerator extends Sprite
	{
		private var m_world:b2World;

		public function AstroidsGenerator(b2dWorld:b2World)
		{
			m_world = b2dWorld;
			addGround();
		}
		
		public function start():void
		{
			var tempAstroid1 : Astroid = new Astroid(m_world, new b2Vec2(8.3, 1));
			addChild(tempAstroid1);	
			
			var tempAstroid2 : Astroid = new Astroid(m_world, new b2Vec2(9.4, 5));
			addChild(tempAstroid2);	
			
			var tempAstroid3 : Astroid = new Astroid(m_world, new b2Vec2(10, 8));
			addChild(tempAstroid3);	
		}
		
		private function addGround():void
		{
			var groundWidth 	: Number = 15;
			var groundHeight 	: Number = 1;
			
			// Add ground body
			var bodyDef : b2BodyDef = new b2BodyDef();
			
			bodyDef.position.Set(groundWidth, groundHeight);
			
			var boxShape : b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(groundWidth, groundHeight);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.friction = 0.3;
			fixtureDef.density = 0;
			
			// Add sprite to body userData
			var box:Quad = new Quad(groundWidth*Consts.pixels_in_a_meter*2, groundHeight*Consts.pixels_in_a_meter*2, 0xCCCCCC);
			box.pivotX = box.width/2; 
			box.pivotY = box.height/2; 
			bodyDef.userData = box;
			
			var body:b2Body;
			body = m_world.CreateBody(bodyDef);
			body.SetPosition(new b2Vec2(0, 20));
			body.CreateFixture(fixtureDef);
			
			Starling.current.stage.addChild(bodyDef.userData);
		}
	}
}