package la.diversion.models.vo
{
	import com.adobe.serialization.json.DiversionJSON;
	
	import flash.utils.Dictionary;
	
	import la.diversion.models.vo.MapAsset;
	
	public class AssetManager
	{
		private var _dic:Dictionary = new Dictionary();
		
		public function AssetManager()
		{
		}
		
		public function addAsset(asset:*):void{
			_dic[asset.id] = asset;
		}
		
		public function getAsset(assetId:String):MapAsset{
			return _dic[assetId];
		}
		
		public function removeAsset(assetId:String):void{
			delete _dic[assetId];
		}
		
		public function get assets():Dictionary{
			return _dic;
		}
		
		public function toJSON():String{
			var assetArray:Array = new Array();
			for each(var ga:* in _dic){
				assetArray.push(ga);
			}
			
			return DiversionJSON.encode(assetArray);
		}
	}
}