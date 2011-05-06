/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 3, 2011
 *
 */

package la.diversion.services {
	import com.adobe.serialization.json.DiversionJSON;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import la.diversion.models.AssetModel;
	import la.diversion.models.SceneModel;
	
	import org.robotlegs.mvcs.Actor;
	
	public class SaveMapService extends Actor implements ISaveMap {
		
		[Inject]
		public var sceneModel:SceneModel;
		
		[Inject]
		public var assetModel:AssetModel;
		
		public function SaveMapService()
		{
			super();
		}
		
		public function SaveMap(file:File):void
		{
			var save:Object = new Object();
			save.assetModel = assetModel;
			save.sceneModel = sceneModel;
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			//fileStream.writeUTFBytes(sceneModel.encodeJSON());
			fileStream.writeUTFBytes(DiversionJSON.encode(save));
			fileStream.close();
		}
	}
}