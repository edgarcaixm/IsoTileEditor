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
	import la.diversion.models.components.GameAsset;
	
	import org.osflash.signals.Signal;
	
	public class UpdatePropertiesViewModeSignal extends Signal
	{
		public function UpdatePropertiesViewModeSignal(...parameters)
		{
			super(String, GameAsset);
		}
	}
}