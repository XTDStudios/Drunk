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
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Astroid extends Sprite
	{
		private var m_body			: b2Body;
		private var m_fixtureDef	: b2FixtureDef;
		private var m_boxShape		: b2PolygonShape;
		private var m_world			: b2World;
		private var m_image			: Image;
		
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
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
	
		private var vX: Number;
		private var vY: Number;
		private var lastX: Number;
		private var lastY: Number;
		private var isMousePress : Boolean = false;
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					trace("touch!!!!");
				}
					
				else if(touch.phase == TouchPhase.MOVED)
				{
					trace("move!!!!");
					vX=lastX;
					vY=lastY;
					lastX=touch.globalX/Consts.pixels_in_a_meter;
					lastY=touch.globalY/Consts.pixels_in_a_meter;
					var b2Vec22:b2Vec2 = new b2Vec2(lastX, lastY);
					m_body.SetPosition(b2Vec22);
					
//					m_bodyDef.position.x=touch.globalX/Consts.pixels_in_a_meter;
//					m_bodyDef.position.y=touch.globalY/Consts.pixels_in_a_meter;
//					var distanceX:Number=bird.x-170;
//					var distanceY:Number=bird.y-270;
//					if (distanceX*distanceX+distanceY*distanceY>10000) {
//						var birdAngle:Number=Math.atan2(distanceY,distanceX);
//						bird.x=170+100*Math.cos(birdAngle);
//						bird.y=270+100*Math.sin(birdAngle);
//					}
				}
					
				else if(touch.phase == TouchPhase.ENDED)
				{
					var currentX:Number = touch.globalX/Consts.pixels_in_a_meter;
					var currentY:Number = touch.globalY/Consts.pixels_in_a_meter;
					trace("end!!!! ("+vX,",",vY,") (",currentX,",",currentY,")");
					m_body.SetLinearVelocity(new b2Vec2(vX-currentX, vY-currentY));
//					bird.buttonMode=false;
//					removeEventListener(MouseEvent.MOUSE_MOVE,birdMoved);
//					removeEventListener(MouseEvent.MOUSE_UP,birdReleased);
//					var sphereShape:b2CircleShape=new b2CircleShape(15/worldScale);
//					var sphereFixture:b2FixtureDef = new b2FixtureDef();
//					sphereFixture.density=1;
//					sphereFixture.friction=3;
//					sphereFixture.restitution=0.1;
//					sphereFixture.shape=sphereShape;
//					var sphereBodyDef:b2BodyDef = new b2BodyDef();
//					sphereBodyDef.type=b2Body.b2_dynamicBody;
//					sphereBodyDef.userData=bird;
//					sphereBodyDef.position.Set(bird.x/worldScale,bird.y/worldScale);
//					birdSphere=world.CreateBody(sphereBodyDef);
//					birdSphere.CreateFixture(sphereFixture);
//					var distanceX:Number=bird.x-170;
//					var distanceY:Number=bird.y-270;
//					var distance:Number=Math.sqrt(distanceX*distanceX+distanceY*distanceY);
//					var birdAngle:Number=Math.atan2(distanceY,distanceX);
//					birdSphere.SetLinearVelocity(new b2Vec2(-distance*Math.cos(birdAngle)/4,-distance*Math.sin(birdAngle)/4));
//					
				}
			}
			
		}
		
	}
}