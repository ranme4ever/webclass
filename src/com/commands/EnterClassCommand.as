package com.commands
{
	import com.constants.NotificationType;
	import com.model.ApplicationModelocator;
	import com.protocol.NetProtocol;
	import com.proxy.ConnectionProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class EnterClassCommand extends SimpleCommand
	{
		public static const ENTER_CLASS:String = "enterClass";
		public function EnterClassCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			switch(notification.getName()){
				case ENTER_CLASS:
					facade.sendNotification(NotificationType.CLASS_STATUS_CHANGE, "正在进入教室...");
					var sendObj:Object = {};
					sendObj.cmd = NetProtocol.CMD_ENTER_CLASS;
					sendObj.uid = ApplicationModelocator.getInstance().UID;
					sendObj.classId=  ApplicationModelocator.getInstance().classId;
					facade.registerCommand(NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_ENTER_CLASS, EnterClassCommand);
					new ConnectionProxy().sendData(sendObj);
					break;
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_ENTER_CLASS:
					onEnterClassHandle(notification.getBody());
					break;
			}
		}
		private function onEnterClassHandle(obj:Object):void {
			facade.sendNotification(NotificationType.CLASS_STATUS_CHANGE, "进入教室成功,正在初始化界面...");
		}
	}
}