package com.mediator
{
	import com.constants.NotificationType;
	import com.protocol.NetProtocol;
	import com.view.RightView;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class RightViewMediator extends Mediator
	{
		public static const RIGHT_VIEW_MEDIATOR:String = "rightViewMediator"
		public function RightViewMediator(viewComponent:Object=null)
		{
			super(RIGHT_VIEW_MEDIATOR, viewComponent);
		}
		
		
		public function get view():RightView{
			return getViewComponent() as RightView;
		}
		[Bindable]
		public var messageProvider:ArrayCollection = new ArrayCollection();
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			var body:Object = notification.getBody();
			switch(notification.getName())
			{
				case NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CHAT_MESSAGE:
					receiveMessageBody(body);
					break;
			}
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return [
				NotificationType.PROTOCOL_CMD_PREFIX + NetProtocol.CHAT_MESSAGE,
			];
		}
		
		private function receiveMessageBody(data:Object):void
		{
			var message:Object = {};
			message.uid = data.sourceId;
			message.sentTime = data.sentTime;
			message.sender = data.sender;
			
			messageProvider.addItem(message);
		}
		
	}
}