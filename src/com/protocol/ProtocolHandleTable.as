package com.protocol
{
	import com.commands.ConnectLbsServerCmd;
	import com.commands.ConnectMediaServer;
	import com.utils.Logger;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ProtocolHandleTable
	{
		public function ProtocolHandleTable()
		{
		}
		
		private static var cmdHandle:Array = [
			{
				cmd: ProtocolType.CMD_CONNECT_LBS,//recive lbs connect confrim message,lbs connect ok
				handle: function (data:Object):void {
					if (data.ResCode != 0) {
						Logger.consoleLog("connect to LBS error,reconnect lbs server " + data.ResCode, Logger.ERROR_LEVEL);
						sendNotification(ConnectLbsServerCmd.BEGIN_CONNECT_LBS_SERVER, data);
						return;
					}
					Logger.consoleLog("connect to LBS success,begin connect media server");
					sendNotification(ConnectMediaServer.CONNECT_MEDIA_SERVER, data)
				}
			}
		]
			
		private static function sendNotification(name:String, body:Object = null, notificationType:String = null):void {
			Facade.getInstance().sendNotification(name, body, notificationType);
		}
	}
}