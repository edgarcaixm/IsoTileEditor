/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Aug 16, 2011
 *
 */

package la.diversion.controllers
{
	import org.robotlegs.mvcs.SignalCommand;
	import la.diversion.models.SceneModel;
	
	public class UpdateTileTerrainCommand extends SignalCommand
	{
		[Inject]
		public var tiles:Array;
		
		[Inject]
		public var terrain:String;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			model.updateTilesTerrain(tiles, terrain);
		}
	}
}