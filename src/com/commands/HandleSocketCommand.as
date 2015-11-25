package com.commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class HandleSocketCommand extends SimpleCommand
	{
		public static const SOCKET_DATA_COMMOND:String = "socketDataCommand"
		public function HandleSocketCommand()
		{
		}
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.execute(notification);
		}
		
	}
}