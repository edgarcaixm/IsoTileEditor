/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 3, 2011
 *
 */

package la.diversion.controllers {
	import la.diversion.services.ILoadAssetLibrary;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LoadAssetLibraryCommand extends SignalCommand {
		
		[Inject]
		public var files:Array;
		
		[Inject]
		public var serviceLoadAssetLibrary:ILoadAssetLibrary;
		
		override public function execute():void{
			serviceLoadAssetLibrary.LoadAssetLibraryFile(files);
		}
	}
}