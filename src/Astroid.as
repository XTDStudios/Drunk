package
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	
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
			m_fixtureDef.density = AstroidWidth*AstroidHeight/10+1;
			m_fixtureDef.friction = 0.0;
			m_fixtureDef.restitution = 0.5;
			m_fixtureDef.userData = "Astroid";
			
			m_bodyDef = new b2BodyDef();
			m_bodyDef.type = b2Body.b2_dynamicBody;
			m_bodyDef.userData = this;
			
			// this is the key line, we pass as a userData the starling.display.Quad
			m_body = m_world.CreateBody(m_bodyDef);
			m_body.SetPosition(position);
			m_body.CreateFixture(m_fixtureDef);

			m_body.ApplyImpulse(new b2Vec2(40*(Math.random()-0.5), 45*Math.random()+30*Math.random()),m_body.GetWorldCenter());
			
			addEventListener(TouchEvent.TOUCH, onTouch2);
		}

		private var mouseJoint			: b2MouseJoint;
		
		private function onTouch2(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch)
			{
				if(touch.phase == TouchPhase.BEGAN)
				{
					var mouse_joint:b2MouseJointDef = new b2MouseJointDef;
					mouse_joint.bodyA = m_world.GetGroundBody();
					mouse_joint.bodyB = m_body;
					mouse_joint.target.Set(touch.globalX/Consts.pixels_in_a_meter, touch.globalY/Consts.pixels_in_a_meter);
					mouse_joint.maxForce = 5000;
					mouseJoint = m_world.CreateJoint(mouse_joint) as b2MouseJoint;
				}
					
				else if(touch.phase == TouchPhase.MOVED)
				{
					mouseJoint.SetTarget(new b2Vec2(touch.globalX/Consts.pixels_in_a_meter, touch.globalY/Consts.pixels_in_a_meter));
				}
					
				else if(touch.phase == TouchPhase.ENDED)
				{
					if (mouseJoint) 
					{
						m_world.DestroyJoint(mouseJoint);
						mouseJoint = null;
					}
				}
			}
		}
				
	}
}