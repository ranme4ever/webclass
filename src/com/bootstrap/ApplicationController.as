package com.bootstrap
{
	import com.commands.ConnectAuthServer;
	import com.commands.ConnectLbsServerCmd;
	import com.commands.ConnectMediaServer;
	import com.commands.EnterClassCommand;
	import com.commands.GetMediaServerInfoCmd;
	import com.commands.GetUserInfoCommand;
	import com.commands.HandleSocketCommand;
	import com.commands.LoginCommand;
	import com.commands.SendDataCommand;
	
	import org.puremvc.as3.core.Controller;

	public class ApplicationController extends Controller
	{
		public function ApplicationController()
		{
			super();
		}
		public static function getInstance() : ApplicationController {
			if ( instance == null ) instance = new ApplicationController( );
			return instance as ApplicationController;
		}
		
		public function initializeCommands():void{
			registerCommand(ConnectLbsServerCmd.BEGIN_CONNECT_LBS_SERVER,ConnectLbsServerCmd);
			registerCommand(ConnectAuthServer.CONNECT_AUTH_SERVER,ConnectAuthServer);
			registerCommand(ConnectAuthServer.RECIEVE_AUTH_SERVER_CONNECT_CONFRIM,ConnectAuthServer)
			
			registerCommand(ConnectMediaServer.CONNECT_MEDIA_SERVER,ConnectMediaServer)
			registerCommand(EnterClassCommand.ENTER_CLASS,EnterClassCommand)
			registerCommand(GetMediaServerInfoCmd.GET_MEDIA_SERVER_INFO,GetMediaServerInfoCmd)
			registerCommand(GetUserInfoCommand.GET_USER_INFO,GetUserInfoCommand);
			registerCommand(LoginCommand.LOGIM_COMMAND,LoginCommand)
			registerCommand(SendDataCommand.SEND_DATA_COMMAND,SendDataCommand);
			registerCommand(HandleSocketCommand.SOCKET_DATA_COMMOND,HandleSocketCommand);
			
		}
		
	}
}