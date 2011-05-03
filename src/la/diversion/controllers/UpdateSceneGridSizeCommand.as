/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 2, 2011
 *
 */

package la.diversion.controllers {
	import org.robotlegs.mvcs.SignalCommand;
	
	import la.diversion.models.SceneModel;
	
	public class UpdateSceneGridSizeCommand extends SignalCommand {
		[Inject]
		public var gridSize:Object;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			trace("UpdateSceneGridSizeCommand:" + gridSize.cols + "," + gridSize.rows);
			model.setGridSize(gridSize.cols, gridSize.rows);
		}
	}
}