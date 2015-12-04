package com.commands
{
	import com.constants.NotificationType;
	import com.model.ApplicationModelocator;
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxy;
	import com.utils.Logger;
	
	import mx.rpc.IResponder;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class GetMediaServerInfoCmd extends SimpleCommand implements IResponder
	{
		public function GetMediaServerInfoCmd()
		{
			super();
		}
		public static const GET_MEDIA_SERVER_INFO:String ="getMediaServerInfo";
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.execute(notification);
			switch(notification.getName()){
				case GET_MEDIA_SERVER_INFO:
					sendNotification(NotificationType.CLASS_STATUS_CHANGE, "正在获取媒体服务器信息...");
					Logger.consoleLog("begin get media server info");
					getClassServerInfo(ApplicationModelocator.getInstance().classId);
					break;
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_CLASS_SERVER_INFO:
					connectMediaServer(notification.getBody());
					break;
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_CONNECT_CLASSROOM:
					if (notification.getBody().ResCode != 0) {
						return;
					}
					startMediaServerHeartBeat();
					sendNotification(EnterClassCommand.ENTER_CLASS);
					break;
					break;
			}
			
		}
		
		private function getClassServerInfo(classid:uint):void
		{
			var sendObj:Object = {};
			sendObj.cmd = NetProtocol.CMD_CLASS_SERVER_INFO;
			sendObj.sourceID = ApplicationModelocator.getInstance().UID;
			sendObj.CID = classid;
			sendObj.FailedServerIP = [];
			Facade.getInstance().registerCommand(NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_CLASS_SERVER_INFO, GetMediaServerInfoCmd);
			new ConnectionProxy().sendData(sendObj);
		}
		private function connectMediaServer(data:Object):void {
			this.sendNotification(NotificationType.CLASS_STATUS_CHANGE, "正在连接媒体服务器...");
			var serverInfo:Object = data;
			if (null == serverInfo) return;
			
			var ipStr:String =serverInfo.ServerIP;
			Logger.consoleLog("MS Info IP: " + ipStr + " Ports: " + serverInfo.ClientPorts.join(' '));
			Logger.consoleLog("begin connect to Media server");
			new ConnectionProxy().connectMediaServer(ipStr, serverInfo.ClientPorts as Array, this);
		}
		
		public function fault(info:Object):void
		{
			
		}
		
		public function result(data:Object):void {
			new ConnectionProxy().mediaService.stopConnectTimer();
			var sendObj:Object = {};
			sendObj.sourceID = ApplicationModelocator.getInstance().UID;
			sendObj.classId = ApplicationModelocator.getInstance().classId;
			sendObj.cmd = NetProtocol.CMD_CONNECT_CLASSROOM;
			facade.registerCommand(NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_CONNECT_CLASSROOM, GetMediaServerInfoCmd);
			new ConnectionProxy().mediaService.sendData(sendObj);
		}
		private function startMediaServerHeartBeat():void {
			Logger.consoleLog("start media server heart beat!");
			new ConnectionProxy().mediaService.startHeartBeat(60 * 1000);
			
		}
	}
}