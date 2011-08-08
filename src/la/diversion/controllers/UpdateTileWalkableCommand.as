/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 1, 2011
 *
 */

package la.diversion.controllers {
	import la.diversion.models.SceneModel;
	import la.diversion.models.vo.Tile;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdateTileWalkableCommand extends SignalCommand {
		//[Inject]
		//public var tile:Tile;
		[Inject]
		public var tiles:Array;
		
		[Inject]
		public var isWalkable:Boolean;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			//model.getTile(tile.col, tile.row).isWalkable = isWalkable;
			model.updateWalkableTilesGroup(tiles, isWalkable);
		}
	}
}