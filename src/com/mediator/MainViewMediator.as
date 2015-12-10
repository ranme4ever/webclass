package com.mediator
{
	import com.constants.NotificationType;
	import com.view.MainView;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainViewMediator extends Mediator
	{
		public function MainViewMediator( viewComponent:Object=null)
		{
			super("mainViewMediator", viewComponent);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.handleNotification(notification);
		}
		
		public function get view():MainView{
			return getViewComponent() as MainView;
		}
		
	}
}