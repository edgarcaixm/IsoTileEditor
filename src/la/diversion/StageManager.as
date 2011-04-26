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
	
	public class StageManager {
		
		private static var _stageLibrary:Dictionary = new Dictionary();
		
		public function StageManager()
		{
		}
		
		public static function addAsset(asset:GameAsset):void{
			_stageLibrary[asset.id] = asset;
		}
		
		public static function getAsset(assetId:String):GameAsset{
			return _stageLibrary[assetId];
		}
		
		public static function removeAsset(assetId:String):void{
			_stageLibrary[assetId] = null;
		}
	}
}