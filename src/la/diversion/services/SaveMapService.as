/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 3, 2011
 *
 */

package la.diversion.services {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.robotlegs.mvcs.Actor;
	
	import la.diversion.models.SceneModel;
	
	public class SaveMapService extends Actor implements ISaveMap {
		
		[Inject]
		public var sceneModel:SceneModel;
		
		public function SaveMapService()
		{
			super();
		}
		
		public function SaveMap(file:File):void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(sceneModel.toJSON());
			fileStream.close();
		}
	}
}