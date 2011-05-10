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
	import la.diversion.models.components.GameAsset;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class UpdatePropertiesViewModeCommand extends SignalCommand
	{
		[Inject]
		public var mode:String;
		
		[Inject]
		public var asset:GameAsset;
		
		[Inject]
		public var model:SceneModel;
		
		override public function execute():void{
			model.setViewModeProperties(mode, asset);
		}
	}
}