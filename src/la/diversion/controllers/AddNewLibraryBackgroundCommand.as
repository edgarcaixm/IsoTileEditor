/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 6, 2011
 *
 */

package la.diversion.controllers
{
	import flash.display.Bitmap;
	
	import la.diversion.models.AssetModel;
	import la.diversion.models.components.Background;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class AddNewLibraryBackgroundCommand extends SignalCommand
	{
		[Inject]
		public var bg:Background;
		
		[Inject]
		public var model:AssetModel;
		
		override public function execute():void{
			model.addBackground(bg);
		}
	}
}