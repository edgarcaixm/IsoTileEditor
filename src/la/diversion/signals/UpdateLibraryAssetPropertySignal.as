/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: May 18, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	import la.diversion.models.components.PropertyUpdate;
	
	public class UpdateLibraryAssetPropertySignal extends Signal
	{
		public function UpdateLibraryAssetPropertySignal(...parameters)
		{
			super(PropertyUpdate);
		}
	}
}