package
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
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
					trace("touch!!!!");
//					var body:b2Body = GetBodyAtMouse(touch.globalX, touch.globalY);
//					if (body) {
						var mouse_joint:b2MouseJointDef = new b2MouseJointDef;
						mouse_joint.bodyA = m_world.GetGroundBody();
						mouse_joint.bodyB = m_body;
						mouse_joint.target.Set(touch.globalX/Consts.pixels_in_a_meter, touch.globalY/Consts.pixels_in_a_meter);
						mouse_joint.maxForce = 10000;
						mouseJoint = m_world.CreateJoint(mouse_joint) as b2MouseJoint;
//					}
				}
					
				else if(touch.phase == TouchPhase.MOVED)
				{
					trace("move!!!!");
					mouseJoint.SetTarget(new b2Vec2(touch.globalX/Consts.pixels_in_a_meter, touch.globalY/Consts.pixels_in_a_meter));
				}
					
				else if(touch.phase == TouchPhase.ENDED)
				{
					trace("end!!!!");
					if (mouseJoint) 
					{
						m_world.DestroyJoint(mouseJoint);
						mouseJoint = null;
					}
				}
			}
		}
		
		
		public function GetBodyAtMouse(mouseX:Number, mouseY:Number):b2Body 
		{
			var real_x_mouse : Number = (mouseX)/Consts.pixels_in_a_meter;
			var real_y_mouse : Number = (mouseY)/Consts.pixels_in_a_meter;
			
			var mousePVec : b2Vec2 = new b2Vec2();
			mousePVec.Set(real_x_mouse, real_y_mouse);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(real_x_mouse - 0.001, real_y_mouse - 0.001);
			aabb.upperBound.Set(real_x_mouse + 0.001, real_y_mouse + 0.001);
			var shapes:Array = new Array();
			
			var body:b2Body = null;
			m_world.QueryAABB(function query(fix:b2Fixture):Boolean
			{
				return true;
			}, aabb);
			
			return body;
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
					m_body.SetLinearVelocity(new b2Vec2(vX-currentX*1000, vY-currentY*1000));
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