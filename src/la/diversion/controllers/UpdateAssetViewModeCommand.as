/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.controllers {
	import la.diversion.models.SceneModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateAssetViewModeCommand extends SignalCommand {
		
		[Inject]
		public var assetMode:String;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			model.viewMode = assetMode;
		}
	}
}