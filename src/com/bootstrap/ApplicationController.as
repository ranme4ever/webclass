package com.bootstrap
{
	import com.commands.ConnectMediaServer;
	import com.commands.ConnectSignalServerCmd;
	import com.commands.EnterClassCommand;
	import com.commands.GetClassInfoCmd;
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
			registerCommand(ConnectSignalServerCmd.BEGIN_CONNECT_SIGNAL_SERVER,ConnectSignalServerCmd);
			
			registerCommand(ConnectMediaServer.CONNECT_MEDIA_SERVER,ConnectMediaServer)
			registerCommand(EnterClassCommand.ENTER_CLASS,EnterClassCommand)
			registerCommand(GetClassInfoCmd.GET_CLASS_INFO,GetClassInfoCmd)
			registerCommand(GetUserInfoCommand.GET_USER_INFO,GetUserInfoCommand);
			registerCommand(LoginCommand.LOGIM_COMMAND,LoginCommand)
			registerCommand(SendDataCommand.SEND_DATA_COMMAND,SendDataCommand);
			registerCommand(HandleSocketCommand.SOCKET_DATA_COMMOND,HandleSocketCommand);
			
		}
		
	}
}