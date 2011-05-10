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
	import la.diversion.models.AssetModel;
	import la.diversion.signals.UpdateAssetViewModeSignal;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateAssetViewModeCommand extends SignalCommand
	{
		[Inject]
		public var viewMode:String;
		
		[Inject]
		public var assetModel:AssetModel;

		override public function execute():void{
			assetModel.viewMode = viewMode;
		}
	}
}