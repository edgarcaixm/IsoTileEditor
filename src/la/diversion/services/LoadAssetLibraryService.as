/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 3, 2011
 *
 */

package la.diversion.services {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import la.diversion.models.components.GameAsset;
	import la.diversion.signals.AddNewLibraryAssetSignal;
	
	import org.robotlegs.mvcs.Actor;
	
	public class LoadAssetLibraryService extends Actor implements ILoadAssetLibrary {
		
		[Inject]
		public var addNewLibraryAsset:AddNewLibraryAssetSignal;
		
		public function LoadAssetLibraryService()
		{
			super();
		}
		
		public function LoadAssetLibraryFile(file:File):void {
			var swfLoader:Loader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoadComplete);
			swfLoader.load(new URLRequest(file.url));
		}
		
		private function onSWFLoadComplete(e:Event):void {
			for each(var assetDef:Object in e.target.content.tiles){
				var tClass:Class = e.target.applicationDomain.getDefinition(assetDef.classRef) as Class;
				var gameAsset:GameAsset = new GameAsset(assetDef.tileID,tClass,assetDef.rows,assetDef.cols,assetDef.height);
				addNewLibraryAsset.dispatch(gameAsset);
			}
		}
	}
}