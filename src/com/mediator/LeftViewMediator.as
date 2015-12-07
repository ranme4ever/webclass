package com.mediator
{
	import com.constants.NotificationType;
	import com.protocol.NetProtocol;
	import com.view.LeftView;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LeftViewMediator extends Mediator
	{
		public function LeftViewMediator(viewComponent:Object=null)
		{
			super("leftViewMediator", viewComponent);
		}
		override public function listNotificationInterests():Array {
			return [NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_COURSEWARE_CHANGE];
		}
		override public function handleNotification(notification:INotification):void {
			super.handleNotification(notification);
			var body:Object = notification.getBody();
			switch(notification.getName()){
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CMD_COURSEWARE_CHANGE:
					switchCourseWare(body);
					break;
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.WRITE_BOARD_DATA:
					view.board.onShowBoard(body);
					break;
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.PPT_DATA:
					view.ppt.onShowPpt(body);
					break;
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CAMERA_DATA:
					view.camera.onShowCamera(body);
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.DESK_SHARE_DATA:
					view.desk.onShowDeskshare(body);
					break
			}
				
		}
		private function switchCourseWare(data:Object):void
		{
			
		}
		private function get view():LeftView {
			return viewComponent as LeftView;
		}

	}
}