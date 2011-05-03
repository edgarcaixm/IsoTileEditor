/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 2, 2011
 *
 */

package la.diversion.views {
	import flash.events.Event;
	
	import la.diversion.models.SceneModel;
	import la.diversion.signals.UpdateSceneGridSizeSignal;
	
	import org.robotlegs.mvcs.SignalMediator;
	
	public class PropertyMediator extends SignalMediator {
		
		[Inject]
		public var view:PropertyView;
		
		[Inject]
		public var model:SceneModel;
		
		[Inject]
		public var updateSceneGridSize:UpdateSceneGridSizeSignal;
		
		override public function onRegister():void{
			this.addToSignal(view.totalCellsHighSignal, handleTotalCellsHighValueCommit);
			this.addToSignal(view.totalCellsWideSignal, handleTotalCellsWideValueCommit);
			
			view.totalCellsHigh.text = "40";
			view.totalCellsWide.text = "40";
			var gridSize:Object = new Object();
			gridSize.cols = 40;
			gridSize.rows = 40;
			updateSceneGridSize.dispatch(gridSize);
			
		}
		
		private function handleTotalCellsHighValueCommit(event:Event):void{
			trace("handleTotalCellsHighValueCommit");
			var gridSize:Object = new Object();
			gridSize.cols = int(event.target["text"]);
			gridSize.rows = model.numRows;
			updateSceneGridSize.dispatch(gridSize);
		}
		
		private function handleTotalCellsWideValueCommit(event:Event):void{
			trace("handleTotalCellsWideValueCommit");
			var gridSize:Object = new Object();
			gridSize.cols = model.numCols;
			gridSize.rows = int(event.target["text"]);
			updateSceneGridSize.dispatch(gridSize);
		}
		
		
	}
}