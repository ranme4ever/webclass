package com.mediator
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		public function MainViewMediator( viewComponent:Object=null)
		{
			super("mainViewMediator", viewComponent);
		}
	}
}