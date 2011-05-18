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
	
	public class IsoSceneStageColorUpdatedSignal extends Signal
	{
		public function IsoSceneStageColorUpdatedSignal(...parameters)
		{
			super(uint);
		}
	}
}