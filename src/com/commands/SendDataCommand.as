package com.commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SendDataCommand extends SimpleCommand
	{
		public static const SEND_DATA_COMMAND:String= "sendDataCommand";
		
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.execute(notification);
		}
		
		public function SendDataCommand()
		{
			super();
		}
	}
}