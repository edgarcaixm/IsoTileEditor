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
	
	public class AssetViewModeUpdatedSignal extends Signal
	{
		public function AssetViewModeUpdatedSignal(...parameters)
		{
			super(String);
		}
	}
}