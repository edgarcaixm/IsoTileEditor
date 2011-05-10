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
	
	import la.diversion.models.components.Background;
	
	public class AddNewLibraryBackgroundSignal extends Signal
	{
		public function AddNewLibraryBackgroundSignal(...parameters)
		{
			super(Background);
		}
	}
}