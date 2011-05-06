/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 4, 2011
 *
 */

package la.diversion.controllers
{
	import flash.filesystem.File;
	
	import la.diversion.services.ILoadMap;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class LoadMapCommand extends SignalCommand
	{
		[Inject]
		public var file:File;
		
		[Inject]
		public var serviceLoadMap:ILoadMap;
		
		override public function execute():void{
			serviceLoadMap.loadMap(file);
		}
		
	}
}