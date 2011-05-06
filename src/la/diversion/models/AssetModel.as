/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.models {
	import flash.utils.Dictionary;
	
	import la.diversion.models.components.AssetManager;
	import la.diversion.models.components.GameAsset;
	import la.diversion.signals.NewLibraryAssetAddedSignal;
	
	import org.robotlegs.mvcs.Actor;
	
	public class AssetModel extends Actor {
		
		[Transient]
		[Inject]
		public var newAssetAdded:NewLibraryAssetAddedSignal;
		
		private var _assetLibrary:Dictionary = new Dictionary();
		private var _assetManager:AssetManager = new AssetManager();
		
		public function AssetModel()
		{
			super();
		}
		
		/**
		 * Add an asset 
		 * 
		 * @param GameAsset
		 * 
		 */
		public function addAsset(asset:GameAsset):void{
			_assetManager.addAsset(asset);
			newAssetAdded.dispatch(asset);
		}
		
		/**
		 * Retreive an asset by assetId
		 * 
		 * @param assetId String
		 * @return GameAsset
		 * 
		 */
		public function getAsset(assetId:String):GameAsset{
			return _assetManager.getAsset(assetId);
		}
		
		public function getAssetByDisplayClass(displayClass:String):GameAsset{
			for each(var asset:GameAsset in _assetManager.assets){
				if(asset.displayClassId == displayClass){
					return asset;
				}
			}
			return null;
		}
		
		/**
		 * Delete an asset
		 * 
		 * @param assetId String
		 * 
		 */
		public function removeAsset(assetId:String):void{
			if(_assetManager.getAsset(assetId)){
				_assetManager.removeAsset(assetId);
			}
		}
		
		/**
		 * Returns the dictionary of all game assets
		 * 
		 * @return Dictionary of game assets
		 * 
		 */
		public function get assetManager():AssetManager{
			return _assetManager;
		}
		
	}
}