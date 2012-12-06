package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	public class AstroidContactListener extends b2ContactListener
	{
		public static const HIT_EVENT : String = "HIT_EVENT";
		
		public var eventDispatcher:EventDispatcher;
		
		public function AstroidContactListener()
		{
			eventDispatcher = new EventDispatcher();
			super();
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			if ((contact.GetFixtureA().GetUserData()=="Ship" && contact.GetFixtureB().GetUserData()=="Astroid") ||
				(contact.GetFixtureA().GetUserData()=="Astroid" && contact.GetFixtureB().GetUserData()=="Ship"))
			{
				eventDispatcher.dispatchEvent(new Event(HIT_EVENT));
			}
		}
	}
}