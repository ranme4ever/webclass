package com.commands
{
	import com.constants.NotificationType;
	import com.model.ApplicationModelocator;
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxyFactory;
	import com.utils.Logger;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class GetClassInfoCmd extends SimpleCommand 
	{
		public function GetClassInfoCmd()
		{
			super();
		}
		public static const GET_CLASS_INFO:String ="getClassInfo";
		override public function execute(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.execute(notification);
			switch(notification.getName()){
				case GET_CLASS_INFO:
					sendNotification(NotificationType.CLASS_STATUS_CHANGE, "正在初始化教室...");
					Logger.consoleLog("begin get media server info");
					getClassServerInfo(ApplicationModelocator.getInstance().classId);
					break;
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_CLASS_SERVER_INFO:
					var classinfo:Object = notification.getBody();
					ApplicationModelocator.getInstance().classId = classinfo.classId;
					ApplicationModelocator.getInstance().courseName = classinfo.courseName;
					ApplicationModelocator.getInstance().teacherName = classinfo.teacherName;
					ApplicationModelocator.getInstance().teacherId = classinfo.teacherId;
					ApplicationModelocator.getInstance().courseTime = classinfo.courseTime;
					sendNotification(NotificationType.CLASS_INIT_COMPLETE);
					break;
			}
			
		}
		
		private function getClassServerInfo(classid:uint):void
		{
			var sendObj:Object = {};
			sendObj.cmd = NetProtocol.CMD_CLASS_SERVER_INFO;
			sendObj.sourceID = ApplicationModelocator.getInstance().uid;
			sendObj.CID = classid;
			sendObj.FailedServerIP = [];
			Facade.getInstance().registerCommand(NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_CLASS_SERVER_INFO, GetClassInfoCmd);
			ConnectionProxyFactory.getConnectionProxy().sendSignalData(sendObj);
		}
		
	}
}