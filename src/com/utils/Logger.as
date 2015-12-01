package com.utils {
import flash.external.ExternalInterface;

import mx.utils.URLUtil;

public class Logger {
    public function Logger() {
    }

    public static var logLevel:int;

    /**
     * 初始化，必须在其它方法前先调用
     */
    public static function init():void {
        var browserUrl:String = ExternalInterface.call("window.location.href.toString");

        var params:Object = URLUtil.stringToObject(browserUrl.slice(browserUrl.indexOf("?") + 1), "&");
        Logger.logLevel = params.hasOwnProperty("logLevel") ? params["logLevel"] : 0;
    }


    public static const ERROR_LEVEL:int = 3;
    public static const WARNING_LEVEL:int = 2;
    public static const DEBUG_LEVEL:int = 1;

    /**
     * 输出控制台日志
     * @param message
     * @param level
     * 通過URL參數logLevel 來控制輸出級別
     *
     */
    public static function consoleLog(message:String, level:int = DEBUG_LEVEL):void {
      
        var prefix:String;
        switch (level) {
            case DEBUG_LEVEL:
                prefix = "Debug";
                break;
            case WARNING_LEVEL:
                prefix = "Warning";
                break;
            case ERROR_LEVEL:
                prefix = "Error";
                break;
            default :
                prefix = "Debug";
                break;
        }
        prefix += ":";
        try {
            if (ExternalInterface.available)
                ExternalInterface.call("console.log('" + prefix + message + "')");
        } catch (e:Error) {

        }

    }

    public static function d(message:String):void {
        consoleLog(message, DEBUG_LEVEL);
    }

    public static function w(message:String):void {
        consoleLog(message, WARNING_LEVEL);
    }

    public static function e(message:String):void {
        consoleLog(message, ERROR_LEVEL);
    }
}
}
