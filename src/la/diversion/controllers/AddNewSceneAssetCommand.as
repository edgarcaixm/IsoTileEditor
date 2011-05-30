/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 30, 2011
 *
 */

package la.diversion.controllers {
	import la.diversion.models.vo.MapAsset;
	import la.diversion.models.SceneModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class AddNewSceneAssetCommand extends SignalCommand {
		
		[Inject]
		public var asset:MapAsset;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			model.addAsset(asset);
		}
	}
}