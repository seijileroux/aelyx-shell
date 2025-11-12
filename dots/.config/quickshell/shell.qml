import qs.core.config
import qs.common
import qs.modules.bar
import qs.modules.background
import qs.modules.border
import qs.modules.launcher
import qs.modules.controlCenter
import qs.modules.powerMenu
import qs.modules.notifications
import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {

    // Initiate Modules
    BorderWindow {}
    //NotificationWindow{}
    Bar {}
    PowerMenu{}
    LauncherWindow{}
    Background{}
    GlobalProcesses{}
    ControlCenter{}

}
