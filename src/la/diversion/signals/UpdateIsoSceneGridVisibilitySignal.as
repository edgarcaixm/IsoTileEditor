/**
 *
 * Copyright (c) 2011 Diversion, Inc.
 *
 * Authors: jobelloyd
 * Created: Aug 5, 2011
 *
 */

package la.diversion.signals
{
	import org.osflash.signals.Signal;
	
	public class UpdateIsoSceneGridVisibilitySignal extends Signal
	{
		public function UpdateIsoSceneGridVisibilitySignal(...parameters)
		{
			super(Boolean);
		}
	}
}