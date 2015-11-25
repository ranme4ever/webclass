package com.mediator
{
	import com.commands.InitConectionCmd;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator
	{
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super("applicationMediator", viewComponent);
		}
		
		private function get main():Main {
			return viewComponent as Main;
		}
		
		override public function onRegister():void {
			sendNotification(InitConectionCmd.BEGIN_CONNECT_LBS_SERVER);
		}
		
		override public function listNotificationInterests():Array {
			return [];
		}
		
		override public function handleNotification(notification:INotification):void {
			super.handleNotification(notification);
		}
		
		
	}
}