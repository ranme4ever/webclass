package com.mediator
{
	import com.commands.ConnectLbsServerCmd;
	import com.constants.NotificationType;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;
	
	import spark.components.RichEditableText;
	
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.events.FlowElementMouseEvent;
	
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
			sendNotification(ConnectLbsServerCmd.BEGIN_CONNECT_LBS_SERVER);
		}
		
		override public function listNotificationInterests():Array {
			return [NotificationType.CLASS_STATUS_CHANGE];
		}
		
		override public function handleNotification(notification:INotification):void {
			super.handleNotification(notification);
			switch(notification.getName()){
				case NotificationType.CLASS_STATUS_CHANGE:
					var body:Object = notification.getBody();
					if (body is String) {
						onclassStatusChange(notification.getBody() as String);
					} else if (body.hasOwnProperty("msg")) {
						onclassStatusChange(body.msg);
						if (body.hasOwnProperty("duration")) {
							if (main.classStatu.visible == false) {
								main.classStatu.visible = true;
							}
							setTimeout(function ():void {
								main.classStatu.visible = false;
							}, body.duration);
						}
					}
					break;
			}
		}
		private function onclassStatusChange(statu:String):void {
			var arr:Array = statu.split("####");
			var p:ParagraphElement = new ParagraphElement();
			var spanPlat:SpanElement = new SpanElement();
			spanPlat.text = arr[0];
			p.addChild(spanPlat);
			if (arr.length > 1) {
				var linkEle:LinkElement = new LinkElement();
				linkEle.addEventListener(FlowElementMouseEvent.CLICK, updatePage);
				var span:SpanElement = new SpanElement();
				span.text = "刷新";
				span.fontSize = 18;
				span.color = 0xFFFFFF;
				linkEle.addChild(span);
				p.addChild(linkEle);
				spanPlat = new SpanElement();
				spanPlat.text = arr[1];
				p.addChild(spanPlat);
			}
			var output:RichEditableText = main.classStatu;
			if (output.textFlow.numChildren > 0)output.textFlow.removeChildAt(0);
			output.textFlow.addChild(p);
			function updatePage(e:Event):void {
				linkEle.removeEventListener(FlowElementMouseEvent.CLICK, updatePage);
				navigateToURL(new URLRequest("javascript:location.reload();"), "_self")
			}
		}

	}
}