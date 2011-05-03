/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Apr 29, 2011
 *
 */

package la.diversion.signals {
	import org.osflash.signals.Signal;
	
	import la.diversion.models.components.GameAsset;
	
	public class AddNewLibraryAssetSignal extends Signal {
		public function AddNewLibraryAssetSignal()
		{
			super(GameAsset);
		}
	}
}