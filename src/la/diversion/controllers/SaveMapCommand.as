/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 3, 2011
 *
 */

package la.diversion.controllers {
	import la.diversion.services.ISaveMap;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	import flash.filesystem.File;
	
	public class SaveMapCommand extends SignalCommand {
		
		[Inject]
		public var file:File;
		
		[Inject]
		public var serviceSaveMap:ISaveMap;
		
		override public function execute():void{
			serviceSaveMap.SaveMap(file);
		}
	}
}