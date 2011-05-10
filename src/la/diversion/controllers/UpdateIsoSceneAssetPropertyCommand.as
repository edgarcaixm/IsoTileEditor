/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 9, 2011
 *
 */

package la.diversion.controllers
{
	import la.diversion.models.SceneModel;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateIsoSceneAssetPropertyCommand extends SignalCommand
	{
		[Inject]
		public var update:Object;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			//model.setGridSize(gridSize.cols, gridSize.rows);
			model.updateSceneAssetProperty(update.assetID, update.assetProperty, update.assetValue);
		}
	}
}