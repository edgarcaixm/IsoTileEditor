/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.controllers {
	import la.diversion.models.components.GameAsset;
	import la.diversion.models.AssetModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class AddNewLibraryAssetCommand extends SignalCommand {
		
		[Inject]
		public var asset:GameAsset;
		
		[Inject]
		public var model:AssetModel;
		
		override public function execute():void{
			model.addAsset(asset);
		}
	}
}