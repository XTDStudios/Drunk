package
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var m_astroidsGenerator	: AstroidsGenerator;
		
		public function Game()
		{
			super();
			m_astroidsGenerator = new AstroidsGenerator();
			addChild(m_astroidsGenerator);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On Game class added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			initGame();
		}
		
		private function initGame():void
		{
			m_astroidsGenerator.start();
		}
		
	}
}