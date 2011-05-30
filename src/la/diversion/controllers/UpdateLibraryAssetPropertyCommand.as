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
	import la.diversion.models.AssetModel;
	import la.diversion.models.vo.PropertyUpdate;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateLibraryAssetPropertyCommand extends SignalCommand
	{
		[Inject]
		public var update:PropertyUpdate;
		
		[Inject]
		public var model:AssetModel;
		
		override public function execute():void{
			model.updateLibraryAssetProperty(update.id, update.editProperty, update.value);
		}
	}
}