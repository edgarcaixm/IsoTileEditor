/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 28, 2011
 *
 */

package la.diversion.controllers
{
	import flash.geom.Point;
	
	import la.diversion.models.SceneModel;
	import la.diversion.models.vo.MapAsset;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class AddMapAssetPathingPointCommand extends SignalCommand
	{
		[Inject]
		public var asset:MapAsset;
		
		[Inject]
		public var pt:Point;
		
		[Inject]
		public var sceneModel:SceneModel;
		
		override public function execute():void{
			sceneModel.addMapAssetPathingPoint(asset.id, pt);
		}
	}
}