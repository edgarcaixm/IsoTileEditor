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
	import la.diversion.models.vo.MapAsset;
	
	import org.osflash.signals.Signal;
	
	public class PropertiesViewModeUpdatedSignal extends Signal
	{
		public function PropertiesViewModeUpdatedSignal(...parameters)
		{
			super(String, MapAsset);
		}
	}
}