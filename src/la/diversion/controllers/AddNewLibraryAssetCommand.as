/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.controllers {
	import la.diversion.models.vo.MapAsset;
	import la.diversion.models.AssetModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class AddNewLibraryAssetCommand extends SignalCommand {
		
		[Inject]
		public var asset:MapAsset;
		
		[Inject]
		public var model:AssetModel;
		
		override public function execute():void{
			model.addAsset(asset);
		}
	}
}