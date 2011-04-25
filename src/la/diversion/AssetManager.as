/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 25, 2011
 *
 */

package la.diversion {
	import flash.utils.Dictionary;

	public class AssetManager {
		
		private static var _assetLibrary:Dictionary = new Dictionary();;
		
		public function AssetManager()
		{
		}
		
		public static function addAsset(asset:GameAsset):void{
			_assetLibrary[asset.id] = asset;
		}
		
		public static function getAsset(assetId:String):GameAsset{
			return _assetLibrary[assetId];
		}
	}
}