package
{
	import com.xtdstudios.DMT.DMTBasic;
	import com.xtdstudios.common.assetsFactory.AssetsFactoryFromAssetsLoader;
	import com.xtdstudios.common.assetsLoader.AssetsLoaderFromByteArray;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import assets.Assets;
	
	import starling.display.DisplayObject;

	public class DMTManager extends EventDispatcher
	{
		private var m_assetsLoader	: AssetsLoaderFromByteArray;
		private var m_assetsFactory	: AssetsFactoryFromAssetsLoader;
		private var m_dmt			: DMTBasic;

		public function DMTManager(screenWidth: int, screenHeight: int)
		{
			super();
			Consts.screenSize_X = screenWidth;
			Consts.screenSize_Y = screenHeight;
			Consts.space_size_X = 30;
			Consts.pixels_in_a_meter = screenWidth / Consts.space_size_X;
			Consts.space_size_Y = Consts.space_size_X / (screenWidth/screenHeight)
		}

		public function initialize():void
		{
			loadAssets();
		}
		
		private function loadAssets():void
		{
			var byteArrays	: Vector.<ByteArray> = new Vector.<ByteArray>;
			byteArrays.push(new Assets.AssetsSwf());
			
			m_assetsLoader = new AssetsLoaderFromByteArray(byteArrays);
			m_assetsFactory = new AssetsFactoryFromAssetsLoader(m_assetsLoader);
			
			m_assetsLoader.addEventListener(Event.COMPLETE, onLoadingComplete);
			
			m_assetsLoader.initializeAllAssets();
		}
		
		private function onLoadingComplete(event:Event):void
		{
			trace(m_assetsLoader.getAvailableAssetsNames());
			initAssets();
		}
		
		private function initAssets():void
		{
			var itemsToRaster : Vector.<flash.display.DisplayObject> = new Vector.<flash.display.DisplayObject>;
			

			// adding the assets to rasterize
			itemsToRaster.push(createAsset("spaceShip", 2*Consts.pixels_in_a_meter, 4*Consts.pixels_in_a_meter)); 
			itemsToRaster.push(createAsset("astroid1", 40, 60));
			itemsToRaster.push(createAsset("astroid2", 30, 40));
			itemsToRaster.push(createAsset("astroid3", 80, 80));
			itemsToRaster.push(createAsset("astroid4", 80, 40));
			itemsToRaster.push(createAsset("astroid5", 70, 70));
			itemsToRaster.push(createAsset("skyAndStars", Consts.screenSize_X, Consts.screenSize_Y));  
			itemsToRaster.push(createAsset("clouds", Consts.screenSize_X, Consts.screenSize_Y));  
			
			m_dmt = new DMTBasic("Drunk", false, "1");
			m_dmt.itemsToRaster = itemsToRaster;
			m_dmt.addEventListener(Event.COMPLETE, onDMTProcessCompleted);
			m_dmt.process();
		}
		
		private function createAsset(assetName:String, w:int, h:int):flash.display.DisplayObject
		{
			var asset : flash.display.DisplayObject = m_assetsFactory.createAsset(assetName) as flash.display.DisplayObject;
			asset.width = w;
			asset.height = h;
			asset.name = assetName; 
			
			return asset;
		}
		
		protected function onDMTProcessCompleted(event:Event):void
		{
			trace();

			dispatchEvent(event);
		}
	
		public function getStarlingDisplayObject(name:String):starling.display.DisplayObject
		{
			return m_dmt.getAssetByUniqueAlias(name)
		}
	}
}