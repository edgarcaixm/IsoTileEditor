/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 18, 2011
 *
 */

package la.diversion.controllers
{
	import flash.filesystem.File;
	
	import la.diversion.models.ApplicationModel;
	
	import org.robotlegs.mvcs.Command;
	
	public class UpdateApplicaitonCurrentFileCommand extends Command
	{
		[Inject]
		public var newFile:File;
		
		[Inject]
		public var applicationModel:ApplicationModel;
		
		override public function execute():void{
			applicationModel.currentFile = newFile;
		}
	}
}