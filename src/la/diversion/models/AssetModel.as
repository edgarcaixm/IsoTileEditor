/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.models {
	import la.diversion.signals.NewLibraryAssetAddedSignal;
	import la.diversion.models.components.GameAsset;
	
	import org.robotlegs.mvcs.Actor;
	
	import flash.utils.Dictionary;
	
	public class AssetModel extends Actor {
		
		[Inject]
		public var newAssetAdded:NewLibraryAssetAddedSignal;
		
		private var _assetLibrary:Dictionary = new Dictionary();
		
		public function AssetModel()
		{
			super();
		}
		
		public function addAsset(asset:GameAsset):void{
			_assetLibrary[asset.id] = asset;
			newAssetAdded.dispatch(asset);
		}
		
		public function getAsset(assetId:String):GameAsset{
			return _assetLibrary[assetId];
		}
		
		public function getAllAssets():Dictionary{
			return _assetLibrary;
		}
	}
}