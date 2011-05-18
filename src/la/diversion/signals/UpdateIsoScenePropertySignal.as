/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 17, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	import la.diversion.models.components.PropertyUpdate;
	
	public class UpdateIsoScenePropertySignal extends Signal
	{
		public function UpdateIsoScenePropertySignal(...parameters)
		{
			super(PropertyUpdate);
		}
	}
}