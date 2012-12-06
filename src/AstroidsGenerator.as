package
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;

	public class AstroidsGenerator extends Sprite
	{
		private var m_world:b2World;
		private var m_dmtManager:DMTManager;
		private var m_timer:Timer;

		public function AstroidsGenerator(b2dWorld:b2World, dmtManager:DMTManager)
		{
			m_world = b2dWorld;
			m_dmtManager = dmtManager;
//			addGround();
		}
		
		public function start():void
		{
			m_timer = new Timer(200);
			m_timer.addEventListener(TimerEvent.TIMER, addAstroid)
			m_timer.start()
				
			addAstroid(null);
		}
		
		private function addAstroid(e:flash.events.Event):void
		{
			var r: int = Math.random()*5 ;
			trace("genAstroid:",r);
			var genAstroid : Boolean = (r <= 2);
			if (genAstroid) {
				var tempAstroid : Astroid = new Astroid(m_world, generateAstroidImage(), new b2Vec2(Math.random()*Consts.space_size_X, -5));
				addChild(tempAstroid);
			}
		}
		
		private function generateAstroidImage():Image
		{
			var imageIdx : int = Math.random()*5+1;
			var image :Image = m_dmtManager.getStarlingDisplayObject("astroid"+imageIdx.toString()) as Image;
			return image;
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