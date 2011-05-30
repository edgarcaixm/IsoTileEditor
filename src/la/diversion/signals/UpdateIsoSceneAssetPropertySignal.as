/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 9, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	import la.diversion.models.vo.PropertyUpdate;
	
	public class UpdateIsoSceneAssetPropertySignal extends Signal
	{
		public function UpdateIsoSceneAssetPropertySignal(...parameters)
		{
			super(PropertyUpdate);
		}
	}
}