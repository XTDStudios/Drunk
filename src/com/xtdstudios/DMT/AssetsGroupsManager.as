/*
Copyright 2012 XTD Studios Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.xtdstudios.DMT
{
	import com.xtdstudios.DMT.persistency.AssetsGroupPersistencyManager;
	import com.xtdstudios.DMT.persistency.ByteArrayPersistencyManager;
	import com.xtdstudios.DMT.persistency.PersistencyManager;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class AssetsGroupsManager
	{
		private var m_assetGroupsDict 				: Dictionary;
		private var m_assetsGroupPersistencyManager	: AssetsGroupPersistencyManager;
		private var m_byteArrayPersistencyManager	: ByteArrayPersistencyManager;
		
		public function AssetsGroupsManager(assetGroupPersistencyManager:AssetsGroupPersistencyManager, byteArrayPersistencyManager:ByteArrayPersistencyManager)
		{
			m_assetsGroupPersistencyManager = assetGroupPersistencyManager;
			m_byteArrayPersistencyManager = byteArrayPersistencyManager;
			m_assetGroupsDict = new Dictionary;
		}
				
		
// ----------------------------- PUBLIC FUNCTIONS ----------------------------------------------
		
		public function build(groupName:String, isGroupTransparent:Boolean=true, matrixAccuracyPercent:Number=1.0):AssetsGroupBuilder
		{
			if (!groupName)
			{
				throw new IllegalOperationError("The groupName cannot be empty");				
			}
			
			if (m_assetGroupsDict[groupName])
			{
				throw new IllegalOperationError("A group with the same name already exist, " + groupName);
			}
			
			var newGroup	: AssetsGroup;
			newGroup = AssetsGroup.getAssetsGroup(groupName, m_byteArrayPersistencyManager);
			m_assetGroupsDict[groupName]=newGroup;
			
			return new AsyncAssetsGroupBuilderImpl(newGroup, isGroupTransparent, matrixAccuracyPercent);
		}

		
		public function get(groupName:String):AssetsGroup
		{
			if (!groupName)
			{
				throw new IllegalOperationError("The groupName cannot be empty");
			}
			
			return m_assetGroupsDict[groupName];
		}
		
		public function get getAssetGroupsDictionary(): Dictionary
		{
			return m_assetGroupsDict;
		}
		
		
		public function loadCache(groupName:String): AssetsGroup {
			var loadData:AssetsGroup = m_assetsGroupPersistencyManager.loadAssetsGroup(groupName);
			loadData.persistencyManager = m_byteArrayPersistencyManager;
			m_assetGroupsDict[groupName]=loadData;
			
			return loadData;
		}
		
		public function saveCacheByName(groupName:String): void {
			var ag:AssetsGroup = get(groupName);
			saveCache(ag);
		}
		
		public function saveCache(assetsGroup:AssetsGroup): void {
			assetsGroup.saveAtlases();
			m_assetsGroupPersistencyManager.saveAssetsGroup(assetsGroup);
		}
		
		public function isCacheExist(groupName:String): Boolean {
			return m_assetsGroupPersistencyManager.isExist(groupName);
		}
		
		/**
		 * This should be refactored.
		 * currently it "know" that the AssetGroup data and the images are start with the same prefix (the groupName), so it use that
		 * to delete all the cache items that start with that prefix.  This logic should be delegate.
		 */
		public function clearCacheByName(groupName:String): void {
			m_assetsGroupPersistencyManager.list().forEach(function(item:String,...ignore:*):void {
				if (!item.indexOf(groupName))
					m_byteArrayPersistencyManager.deleteData(item);
			});
//			var ag:AssetsGroup = get(groupName);
//			if (ag)
//				clearCache(ag);
		}
		
		public function clearCache(assetsGroup:AssetsGroup): void {
			clearCacheByName(assetsGroup.name);
//			assetsGroup.deleteAtlases();
//			m_assetsGroupPersistencyManager.deleteData(assetsGroup.name);
		}
		
		
		public function dispose():void
		{
			if (m_assetGroupsDict)
			{
				for (var key:Object in m_assetGroupsDict)
				{
					m_assetGroupsDict[key].dispose();
				}
				m_assetGroupsDict = null;
			}
			
			m_assetsGroupPersistencyManager = null;
		}
	}
}