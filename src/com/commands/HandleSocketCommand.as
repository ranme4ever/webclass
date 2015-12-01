package com.commands
{
	import com.constants.NotificationType;
	import com.protocol.ProtocolHandleTable;
	import com.utils.Logger;
	
	import flash.utils.Dictionary;
	
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
			var cmdHandleTabel:Dictionary = ProtocolHandleTable.getProtocolCmdHandleTabel();
			if(notification.getBody().hasOwnProperty("cmd"))
			{
				var cmd:Object = notification.getBody()["cmd"];
				var type:String = notification.getType();
				Logger.consoleLog(type+" receive a packet CMD:0x"+uint(cmd).toString(16));
				if(cmdHandleTabel[cmd] is Function)
				{	
					cmdHandleTabel[cmd](notification.getBody());
				}else//dispense cmd notification{
				{
					sendNotification(NotificationType.PROTOCOL_CMD_PREFIX+cmd,notification.getBody(),notification.getType());
				}
			}
		}
		
	}
}