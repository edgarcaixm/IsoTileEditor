/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 6, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	public class UpdateAssetViewModeSignal extends Signal
	{
		public function UpdateAssetViewModeSignal()
		{
			super(String);
		}
	}
}