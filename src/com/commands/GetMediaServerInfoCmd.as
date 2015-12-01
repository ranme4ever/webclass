package com.commands
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GetMediaServerInfoCmd extends SimpleCommand
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
		}
		
	}
}